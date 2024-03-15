# frozen_string_literal: true

# Schedules Controller
class SchedulesController < ApplicationController
  include DashboardData
  before_action :set_current_account

  # GET /accounts/:account_id/schedules
  def index
    load_limit

    respond_to do |format|
      format.html do
        @nb_schedules = current_schedules.count
        schedules(limit: @limit)
        @all_user_schedules = Schedule.where(account: @current_accounts)
      end
      format.turbo_stream do
        @nb_schedules = current_schedules.count
        @nb_items = params[:offset].to_i.abs + @limit
        schedules(offset: params[:offset].to_i.abs, limit: @limit)
      end
      format.csv do
        attributes_to_extract = %w[id account_id next_time frequency period]
        send_data current_schedules.to_csv(attributes_to_extract),
                  filename: "schedules_#{timestamp_for_export}.csv",
                  type:     "text/csv"
      end
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
    schedule

    @sign = @schedule.operation.amount.negative? ? "debit" : "credit"
    @schedule.operation.amount = @schedule.operation.amount.abs
  end

  # POST /accounts/:account_id/schedules
  def create
    build_schedule

    # TODO: could be refactored with update?
    @schedule.account = @current_account
    @schedule.operation.account = @current_account

    if save_schedule
      redirect_to account_schedules_url(@current_account), notice: t(".successfully_created")
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /schedules/:id
  def update
    schedule
    build_schedule

    # TODO: could be refactored with create?
    @schedule.account = @current_account
    @schedule.operation.account = @current_account

    if save_schedule
      redirect_to account_schedules_url(@current_account), notice: t(".successfully_updated"), status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /schedules/:id
  def destroy
    schedule
    if @schedule.destroy
      respond_to do |format|
        format.html { redirect_to account_schedules_url(@current_account), notice: t(".successfully_destroyed") }
        format.turbo_stream do
          @successful_destroy = true
          @nb_schedules = current_schedules.count
          flash.now[:notice] = t(".successfully_destroyed")
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to account_schedules_url(@current_account), warning: t(".cant_destroy") }
        format.turbo_stream do
          @successful_destroy = false
          flash.now[:warning] = t(".cant_destroy")
        end
      end
    end
  end

  # POST /schedules/:id/insert
  def insert
    schedule

    transaction = @schedule.operation.dup
    transaction.schedule_id = nil
    userstamp(transaction)
    transaction.created_by = @current_user.id

    @schedule.next_time = @schedule.next_time.advance(@schedule.period.to_sym => @schedule.frequency)
    userstamp(@schedule)

    transaction.save
    @schedule.save

    begin
      respond_to do |format|
        format.html { redirect_to dashboard_url, notice: t(".successfully_inserted"), status: :see_other }
        format.turbo_stream do
          load_transactions
          load_current_transactions
          load_schedules
          flash[:notice] = t(".successfully_inserted") unless params[:origin] == "dashboard"
        end
      end
    rescue StandardError
      redirect_to dashboard_url, notice: t(".successfully_inserted")
    end
  end

  private ##############################################################################################################

    def schedules(options = {})
      @schedules ||= current_schedules.offset(options[:offset]).limit(options[:limit]).order_by_next_time_and_id
    end

    def schedule
      @schedule ||= current_schedules.find(params[:id])
    end

    def build_schedule
      @schedule ||= current_schedules.build
      @schedule.attributes = schedule_params
    end

    def schedule_params
      schedule_params = params[:schedule]
      if schedule_params
        schedule_params.permit(:account_id,
                               :next_time,
                               :frequency,
                               :period,
                               operation_attributes: %i[amount category_id comment checked])
      else
        {}
      end
    end

    def save_schedule
      return unless @schedule.save

      if params[:sign] == "credit"
        @schedule.operation.amount = @schedule.operation.amount.abs if @schedule.operation.amount.present?
      elsif @schedule.operation.amount.present?
        @schedule.operation.amount = @schedule.operation.amount.abs * -1
        @schedule.operation.save
      end

      userstamp(@schedule)
    end

    def current_schedules
      @current_account.schedules
    end
end
