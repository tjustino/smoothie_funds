# == Schema Information
#
# Table name: schedules
#
#  id             :integer          not null, primary key
#  account_id     :integer          not null
#  transaction_id :integer          not null
#  next_time      :date             not null
#  frequency      :integer          not null
#  period         :string(255)      not null
#  created_by     :integer
#  updated_by     :integer
#  created_at     :datetime
#  updated_at     :datetime
#

class Schedule < ActiveRecord::Base
  #PERIODS = [ :day, :weeks, :months, :years]

  belongs_to :account
  #belongs_to :transaction
  # You tried to define an association named transaction on the model Schedule, 
  # but this will conflict with a method transaction already defined by Active 
  # Record. Please choose a different association name. (ArgumentError)
  belongs_to :transac, class_name: "Transaction", foreign_key: "transaction_id"

  validates_presence_of     :next_time, :frequency, :period #, :account_id, :transaction_id
  validates_numericality_of :frequency
end
