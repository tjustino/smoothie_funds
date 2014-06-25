# == Schema Information
#
# Table name: schedules
#
#  id         :integer          not null, primary key
#  account_id :integer          not null
#  next_time  :date             not null
#  frequency  :integer          not null
#  period     :string(255)      not null
#  created_by :integer
#  updated_by :integer
#  created_at :datetime
#  updated_at :datetime
#

class Schedule < ActiveRecord::Base
  #PERIODS = [ :day, :weeks, :months, :years]

  #has_one :operation, foreign_key: "schedule_id", class_name: "Transaction"
  #accepts_nested_attributes_for :operation, allow_destroy: true
  has_many :transactions, dependent: :delete_all
  accepts_nested_attributes_for :transactions, allow_destroy: true

  belongs_to  :account

  validates_presence_of     :account_id, :next_time, :frequency, :period
  validates_numericality_of :frequency
end
