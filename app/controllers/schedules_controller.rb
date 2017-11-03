class SchedulesController < ApplicationController
  before_action :set_current_account

  # GET /accounts/:account_id/schedules
  def index
    load_limit

    if params[:offset]
      load_schedules( params[:offset].to_i.abs, @limit )
    else
      @limit = params[:limit].to_i * @limit unless params[:limit].blank?
      load_schedules( nil, @limit )
      @all_user_schedules = Schedule.where(account: @current_accounts)
    end
  end

  # GET /accounts/:account_id/schedules/new
  def new
    build_schedule
    @schedule.build_operation
    @sign = "debit"
  end

  # GET /schedules/:id/edit
  def edit
    load_schedule
    #build_schedule

    @schedule.operation.amount < 0 ? @sign = "debit" : @sign = "credit"
    @schedule.operation.amount = @schedule.operation.amount.abs
  end

  # POST /accounts/:account_id/schedules
  def create
    build_schedule

    #TODO could be refactored with update?
    @schedule.account = @current_account
    @schedule.operation.account = @current_account

    save_schedule( t('.successfully_created') ) or render 'new'
  end

  # PATCH/PUT /schedules/:id
  def update
    load_schedule
    build_schedule

    #TODO could be refactored with create?
    @schedule.account = @current_account
    @schedule.operation.account = @current_account

    save_schedule( t('.successfully_updated') ) or render 'edit'
  end

  # DELETE /schedules/:id
  def destroy
    load_schedule
    if @schedule.destroy
      redirect_to account_schedules_url(@current_account),
                  notice: t('.successfully_destroyed')
    else
      flash[:warning] = t('.cant_destroy')
      redirect_to account_schedules_url(@current_account)
    end
  end

  # POST /schedules/:id/insert
  def insert
    load_schedule

    transaction = @schedule.operation.dup
    transaction.schedule_id = nil
    userstamp(transaction)
    transaction.created_by  = @current_user.id

    @schedule.next_time  = @schedule.next_time.advance(@schedule.period.to_sym => @schedule.frequency)
    userstamp(@schedule)

    transaction.save
    @schedule.save

    begin
      if Rails.application.routes.recognize_path(request.referrer)[:controller] == "schedules"
        load_limit
        redirect_to account_schedules_url(
                              @current_account,
                              limit: (params[:index].to_f / @limit.to_f).ceil ),
                              notice: t('.successfully_inserted')
      else
        redirect_to dashboard_url, notice: t('.successfully_inserted')
      end
    rescue
      redirect_to dashboard_url, notice: t('.successfully_inserted')
    end
  end

  private ######################################################################

    def load_schedules(offset=nil, limit=nil)
      @nb_schedules = current_schedules.count
      @schedules ||= current_schedules.offset(offset).limit(limit).order_by_next_time_and_id
    end

    def load_schedule
      @schedule ||= current_schedules.find(params[:id])
    end

    def build_schedule
      @schedule ||= current_schedules.build
      @schedule.attributes = schedule_params
    end

    def schedule_params
      schedule_params = params[:schedule]
      if schedule_params
        schedule_params.permit( :account_id,
                                :next_time,
                                :frequency,
                                :period,
                                operation_attributes: [ :amount,
                                                        :category_id,
                                                        :comment,
                                                        :checked ] )
      else
        {}
      end
    end

    def save_schedule(notice)
      if @schedule.save
        if params[:sign] == "credit"
          @schedule.operation.amount = @schedule.operation.amount.abs if not @schedule.operation.amount.blank?
        else
          # TODO to refactor
          @schedule.operation.amount = -1 * @schedule.operation.amount.abs if not @schedule.operation.amount.blank?
          @schedule.operation.save if not @schedule.operation.amount.blank?
        end

        userstamp(@schedule)
        redirect_to( account_schedules_url(@current_account), notice: notice ) if notice
      end
    end

    def current_schedules
      @current_account.schedules
    end
end
