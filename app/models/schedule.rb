# == Schema Information
#
# Table name: schedules
#
#  id         :integer          not null, primary key
#  created_by :integer
#  frequency  :integer          not null
#  next_time  :date             not null
#  period     :string           not null
#  updated_by :integer
#  created_at :datetime
#  updated_at :datetime
#  account_id :integer          not null
#
# Indexes
#
#  index_schedules_on_account_id  (account_id)
#  index_schedules_on_created_by  (created_by)
#  index_schedules_on_updated_by  (updated_by)
#
# Foreign Keys
#
#  account_id  (account_id => accounts.id)
#  created_by  (created_by => users.id)
#  updated_by  (updated_by => users.id)
#

class Schedule < ApplicationRecord
  has_one :operation, class_name: "Transaction", dependent: :destroy, inverse_of: :schedule
  accepts_nested_attributes_for :operation, update_only: true, allow_destroy: true
  belongs_to :account

  scope :order_by_next_time_and_id, -> { order(next_time: :asc, id: :asc) }

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
