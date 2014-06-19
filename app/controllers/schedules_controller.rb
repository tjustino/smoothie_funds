class SchedulesController < ApplicationController
  before_action :set_schedule, only: [:edit, :update, :destroy]
  before_action :set_current_account

  # GET /users/1/accounts/1/schedules
  def index
    @schedules = Schedule.all
  end

  # GET /users/1/accounts/1/schedules/new
  def new
    @schedule = Schedule.new
  end

  # GET /users/1/accounts/1/schedules/1/edit
  def edit
  end

  # POST /users/1/accounts/1/schedules
  def create
    @schedule = Schedule.new(schedule_params)

    respond_to do |format|
      if @schedule.save
        format.html { redirect_to @schedule, notice: 'Schedule was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /users/1/accounts/1/schedules/1
  def update
    respond_to do |format|
      if @schedule.update(schedule_params)
        format.html { redirect_to @schedule, notice: 'Schedule was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /users/1/accounts/1/schedules/1
  def destroy
    @schedule.destroy
    respond_to do |format|
      format.html { redirect_to schedules_url, notice: 'Schedule was successfully destroyed.' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_schedule
      @schedule = Schedule.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def schedule_params
      params.require(:schedule).permit(:account_id, :transaction_id, :next_time, :frequency, :period)
    end
end
