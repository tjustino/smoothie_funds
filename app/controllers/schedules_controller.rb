class SchedulesController < ApplicationController
  before_action :set_current_account

  # GET /accounts/:account_id/schedules
  def index
    load_schedules
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
      redirect_to account_schedules_url, notice: t('.successfully_destroyed')
    else
      flash[:warning] = t('.cant_destroy')
      redirect_to account_schedules_url
    end
  end

  # POST /schedules/:id/insert
  def insert
    #TODO to be refactored
    load_schedule

    transaction = @schedule.operation.dup
    transaction.schedule_id = nil
    userstamp(transaction)
    transaction.created_by  = @current_user.id

    @schedule.next_time  = @schedule.next_time.advance(@schedule.period.to_sym => @schedule.frequency)
    userstamp(@schedule)

    transaction.save
    @schedule.save

    redirect_to :back, notice: t('.successfully_inserted')
  end

  private ######################################################################

    def load_schedules
      #TODO remove kaminari
      @nb_schedules = current_schedules.count
      @schedules ||= current_schedules.order_by_next_time_and_id.page(params[:page]).per(20)
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
      schedule_params ? schedule_params.permit(:account_id, :next_time, :frequency, :period, operation_attributes: [:amount, :category_id, :comment, :checked]) : {}
    end

    def save_schedule(notice)
      if @schedule.save
        if params[:sign] == "credit"
          @schedule.operation.amount = @schedule.operation.amount.abs if not @schedule.operation.amount.blank?
        else
          @schedule.operation.amount = -1 * @schedule.operation.amount.abs if not @schedule.operation.amount.blank?
        end

        userstamp(@schedule)
        redirect_to( account_schedules_url, notice: notice ) if notice
      end
    end

    def current_schedules
      @current_account.schedules
    end
end
