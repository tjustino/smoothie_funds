# == Schema Information
#
# Table name: transactions
#
#  id          :integer          not null, primary key
#  account_id  :integer          not null
#  category_id :integer          not null
#  date        :date             not null
#  amount      :decimal(8, 2)    not null
#  checked     :boolean
#  comment     :text
#  created_by  :integer
#  updated_by  :integer
#  created_at  :datetime
#  updated_at  :datetime
#  schedule_id :integer
#

class Transaction < ActiveRecord::Base
  attr_accessor :balance

  belongs_to  :account
  belongs_to  :category
  belongs_to  :schedule

  validates_presence_of     :account_id, :category_id, :date, :amount
  validates_numericality_of :amount
end
