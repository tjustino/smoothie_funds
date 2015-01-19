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

class Schedule < ActiveRecord::Base
  has_one :operation, foreign_key: "schedule_id",
                      class_name: "Transaction",
                      dependent: :destroy

  accepts_nested_attributes_for :operation, allow_destroy: true

  belongs_to :account

  validates_presence_of     :account_id, :next_time, :frequency, :period, :operation
  validates_numericality_of :frequency

  before_validation :populate_date

  private
    def populate_date
      unless self.next_time.nil? || self.operation.nil?
        self.operation.date = self.next_time
        self.operation.save
      end
    end
end
