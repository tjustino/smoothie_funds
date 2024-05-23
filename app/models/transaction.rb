# frozen_string_literal: true

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

# Transaction model
class Transaction < ApplicationRecord
  belongs_to :account
  belongs_to :category
  belongs_to :schedule, optional: true

  scope :order_by_date_and_id,      -> { order(date: :asc,  id: :asc) }
  scope :order_by_date_and_id_desc, -> { order(date: :desc, id: :desc) }
  scope :active,                    -> { where(schedule_id: nil) }
  scope :checked,                   -> { where(checked: true) }

  before_validation :format_amount

  validates :date,   presence: true, inclusion: { in: (Date.new(2000, 1, 1)..Date.new(2099, 12, 31)) }
  validates :amount, presence: true, numericality: true

  private ######################################################################

    def format_amount
      return if amount.blank?

      self.amount = amount_before_type_cast.to_s
                                           .strip
                                           .tr_s(" ", "")
                                           .tr_s(",", ".")
    end

    class << self
      def with_balances_for(account)
        adding_balance_column = "*,
          ( ( SUM(amount) OVER ( ORDER BY date ASC, id ASC
             ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW ) ) +
            ( SELECT initial_balance FROM accounts WHERE id = #{account.id} )
          ) AS balance"

        select(adding_balance_column)
      end

      def search_accounts(accounts)
        where(account_id: accounts)
      end

      def search_amount(min, max)
        if min.present? && max.present?
          where([ "amount > ? and amount < ?", min, max ])
        elsif min.present? && max.blank?
          where([ "amount > ?", min ])
        elsif min.blank? && max.present?
          where([ "amount < ?", max ])
        else
          where("1=1")
        end
      end

      def search_date(before, after)
        if before.present? && after.present?
          where([ "date < ? and date > ?", before, after ])
        elsif before.present? && after.blank?
          where([ "date < ?", before ])
        elsif before.blank? && after.present?
          where([ "date > ?", after ])
        else
          where("1=1")
        end
      end

      def search_categories(categories)
        where(category_id: categories)
      end

      def search_comment(operator, comment)
        case operator
        when "like"
          if comment.present?
            where(["UPPER(transactions.comment) LIKE ?", "%#{comment.upcase}%"])
          else
            where(comment: nil)
          end
        when "not_like"
          if comment.present?
            where(["UPPER(transactions.comment) NOT LIKE ?", "%#{comment.upcase}%"])
          else
            where.not(comment: nil)
          end
        else
          where("1=1")
        end
      end

      def search_checked(checked)
        case checked
        when "yep"
          where(checked: true)
        when "nop"
          where(checked: false)
        else
          where("1=1")
        end
      end
    end
end
