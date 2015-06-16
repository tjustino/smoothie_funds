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

  scope :order_by_date_and_id,      -> { order(date: :asc,  id: :asc) }
  scope :order_by_date_and_id_desc, -> { order(date: :desc, id: :desc) }
  scope :active,                    -> { where(schedule_id: nil) }
  scope :checked,                   -> { where(checked: true) }

  before_validation         :format_amount

  validates_presence_of     :account_id, :category_id, :date, :amount
  validates_numericality_of :amount


  private ######################################################################

    def format_amount
      if amount.present?
        self.amount = amount_before_type_cast.to_s.gsub(' ', '').gsub(',', '.')
      end
    end

  def self.search_accounts(accounts)
    where(account_id: accounts)
  end

  def self.search_amount(min, max)
    if    not min.blank?  and not max.blank?
      where( ["amount > ? and amount < ?", min, max] )
    elsif not min.blank?  and max.blank?
      where( ["amount > ?", min] )
    elsif min.blank?      and not max.blank?
      where( ["amount < ?", max] )
    else
      where( "1=1" )
    end
  end

  def self.search_date(before, after)
    if    not before.blank? and not after.blank?
      where( ["date < ? and date > ?", before, after] )
    elsif not before.blank? and after.blank?
      where( ["date < ?", before] )
    elsif before.blank?     and not after.blank?
      where( ["date > ?", after] )
    else
      where( "1=1" )
    end
  end

  def self.search_categories(categories)
    where(category_id: categories)
  end

  def self.search_comment(operator, comment)
    if    operator == "like"      and not comment.blank?
      where( "UPPER(comment) LIKE UPPER('%#{comment}%')" )
    elsif operator == "like"      and comment.blank?
      where( "comment IS NOT NULL" )
    elsif operator == "not_like"  and not comment.blank?
      where( "UPPER(comment) NOT LIKE UPPER('%#{comment}%')" )
    elsif operator == "not_like"  and comment.blank?
      where( "comment IS NULL" )
    else
      where( "1=1" )
    end
  end

  def self.search_checked(checked)
    if    checked == "yep"
      where(checked: true)
    elsif checked == "nop"
      where(checked: false)
    else
      where( "1=1" )
    end
  end
end
