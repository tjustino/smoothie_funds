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

  scope :order_by_date_and_id,  -> { order(date: :asc, id: :asc) }
  scope :active,                -> { where(schedule_id: nil) }
  scope :checked,               -> { where(checked: true) }

  before_validation         :format_amount

  validates_presence_of     :account_id, :category_id, :date, :amount
  validates_numericality_of :amount


  private ######################################################################

    def format_amount
      if amount.present?
        self.amount = amount_before_type_cast.to_s.gsub(' ', '').gsub(',', '.')
      end
    end
end
