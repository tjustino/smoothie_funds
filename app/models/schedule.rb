# frozen_string_literal: true

# == Schema Information
#
# Table name: schedules
#
#  id         :integer          not null, primary key
#  account_id :integer          not null
#  next_time  :date             not null
#  frequency  :integer          not null
#  period     :string           not null
#  created_by :integer
#  updated_by :integer
#  created_at :datetime
#  updated_at :datetime
#

# Schedule model
class Schedule < ApplicationRecord
  # BUG : Edit 1 schedule, remove amoutn an confirm -> Error
  # transaction was deleted (why?) but not the schedule. Must delete schedule:
  #   Schedule.delete 688540077
  has_one :operation, foreign_key: "schedule_id",
                      class_name:  "Transaction",
                      dependent:   :destroy,
                      inverse_of:  :schedule

  accepts_nested_attributes_for :operation, allow_destroy: true

  belongs_to :account

  scope :order_by_next_time_and_id, -> { order(next_time: :asc, id: :asc) }

  validates :account_id, presence:     true
  validates :next_time,  presence:     true
  validates :frequency,  presence:     true
  validates :period,     presence:     true
  validates :operation,  presence:     true
  validates :frequency,  numericality: true

  before_validation :populate_date

  private

    def populate_date
      return if next_time.nil? || operation.nil?

      operation.date = next_time
      operation.save
    end
end
