# frozen_string_literal: true

# Schedules Controller
class SchedulesController < ApplicationController
  before_action :set_current_account

  # GET /accounts/:account_id/schedules
  def index
    load_limit

    if params[:offset]
      schedules(params[:offset].to_i.abs, @limit)
    else
      @limit = params[:limit].to_i * @limit if params[:limit].present?
      schedules(nil, @limit)
      @all_user_schedules = Schedule.where(account: @current_accounts)
    end

    respond_to do |format|
      format.html
      format.js.coffee
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

    save_schedule(t(".successfully_created")) || render("new")
  end

  # PATCH/PUT /schedules/:id
  def update
    schedule
    build_schedule

    # TODO: could be refactored with create?
    @schedule.account = @current_account
    @schedule.operation.account = @current_account

    save_schedule(t(".successfully_updated")) || render("edit")
  end

  # DELETE /schedules/:id
  def destroy
    schedule
    if @schedule.destroy
      redirect_to account_schedules_url(@current_account),
                  notice: t(".successfully_destroyed")
    else
      flash[:warning] = t(".cant_destroy")
      redirect_to account_schedules_url(@current_account)
    end
  end

  # POST /schedules/:id/insert
  def insert
    schedule

    transaction = @schedule.operation.dup
    transaction.schedule_id = nil
    userstamp(transaction)
    transaction.created_by = @current_user.id

    @schedule.next_time = @schedule.next_time.advance(
      @schedule.period.to_sym => @schedule.frequency
    )
    userstamp(@schedule)

    transaction.save
    @schedule.save

    begin
      if current_controller == "schedules"
        load_limit
        redirect_to account_schedules_url(
          @current_account, limit: (params[:index].to_f / @limit.to_f).ceil
        ), notice: t(".successfully_inserted")
      else
        redirect_to dashboard_url, notice: t(".successfully_inserted")
      end
    rescue StandardError
      redirect_to dashboard_url, notice: t(".successfully_inserted")
    end
  end

  private ######################################################################

    def schedules(offset = nil, limit = nil)
      @nb_schedules = current_schedules.count
      @schedules ||= current_schedules.offset(offset)
                                      .limit(limit)
                                      .order_by_next_time_and_id
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
                               operation_attributes: %i[amount
                                                        category_id
                                                        comment
                                                        checked])
      else
        {}
      end
    end

    def save_schedule(notice)
      return unless @schedule.save

      if params[:sign] == "credit"
        if @schedule.operation.amount.present?
          @schedule.operation.amount = @schedule.operation.amount.abs
        end
      else
        # TODO: to refactor
        if @schedule.operation.amount.present?
          @schedule.operation.amount = -1 * @schedule.operation.amount.abs
        end
        @schedule.operation.save if @schedule.operation.amount.present?
      end

      userstamp(@schedule)
      return unless notice

      redirect_to(account_schedules_url(@current_account), notice: notice)
    end

    def current_schedules
      @current_account.schedules
    end

    def current_controller
      Rails.application.routes.recognize_path(request.referer)[:controller]
    end
end
