class SchedulesController < ApplicationController
  before_action :set_schedule, only: [:edit, :update, :destroy]
  before_action :set_current_account

  # GET /users/1/accounts/1/schedules
  def index
    @schedules = @current_account.schedules.order(next_time: :asc, id: :asc)
  end

  # GET /users/1/accounts/1/schedules/new
  def new
    @schedule = Schedule.new
    @schedule.build_operation
    @sign = "debit"
  end

  # GET /users/1/accounts/1/schedules/1/edit
  def edit
    @schedule.operation.amount < 0 ? @sign = "debit" : @sign = "credit"
    @schedule.operation.amount = @schedule.operation.amount.abs
  end

  # POST /users/1/accounts/1/schedules
  def create
    @schedule = Schedule.new(schedule_params)

    @schedule.account     = @current_account
    @schedule.created_by  = @current_user.id
    @schedule.updated_by  = @current_user.id

    @schedule.operation.date        = @schedule.next_time
    @schedule.operation.account     = @current_account
    #@schedule.operation.created_by  = @current_user.id
    #@schedule.operation.updated_by  = @current_user.id

    if params[:sign] == "credit"
      @schedule.operation.amount = @schedule.operation.amount.abs if not @schedule.operation.amount.blank?
    else
      @schedule.operation.amount = -1 * @schedule.operation.amount.abs if not @schedule.operation.amount.blank?
    end

    respond_to do |format|
      if @schedule.save
        format.html { redirect_to user_account_schedules_url, notice: t('.successfully_created') }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /users/1/accounts/1/schedules/1
  def update
    t_params = schedule_params

    if params[:sign] == "credit"
      t_params[:operation_attributes][:amount] = t_params[:operation_attributes][:amount].to_f.abs if not t_params[:operation_attributes][:amount].blank?
    else
      t_params[:operation_attributes][:amount] = -1 * t_params[:operation_attributes][:amount].to_f.abs if not t_params[:operation_attributes][:amount].blank?
    end

    t_params[:operation_attributes][:date]    = t_params[:next_time]
    t_params[:operation_attributes][:account] = @current_account

    respond_to do |format|
      if @schedule.update(t_params)
        format.html { redirect_to user_account_schedules_url, notice: t('.successfully_updated') }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /users/1/accounts/1/schedules/1
  def destroy
    @schedule.destroy
    respond_to do |format|
      format.html { redirect_to user_account_schedules_url, notice: t('.successfully_destroyed') }
    end
  end

  # POST /users/1/accounts/1/schedules/1/insert
  def insert
    puts "@@@@@@@@@@@@@@@@@@@@@@"
    puts "INSERT !!"
    puts "@@@@@@@@@@@@@@@@@@@@@@"

    respond_to do |format|
      format.html { redirect_to user_account_schedules_url, notice: t('.successfully_inserted') }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_schedule
      @schedule = Schedule.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def schedule_params
      params.require(:schedule).permit( :account_id,
                                        :next_time,
                                        :frequency,
                                        :period,
                                        operation_attributes: [ :amount,
                                                                :category_id,
                                                                :comment,
                                                                :checked ])
    end
end
