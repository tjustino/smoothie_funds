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

require "test_helper"

# Transaction Model Test
class TransactionTest < ActiveSupport::TestCase
  test "should create transaction" do
    account = random_account

    transaction = Transaction.new(account:  account,
                                  category: some_category_for(account),
                                  date:     Time.zone.now,
                                  amount:   42,
                                  checked:  true,
                                  comment:  "Super comment !!!")

    assert transaction.valid?
  end

  test "account_id, category_id, date and amount must not be empty" do
    transaction = Transaction.new

    assert       transaction.invalid?
    assert_equal [ I18n.t("activerecord.errors.models.transaction.attributes.account.required") ],
                 transaction.errors[:account]
    assert_equal [ I18n.t("activerecord.errors.models.transaction.attributes.category.required") ],
                 transaction.errors[:category]
    assert_equal [ I18n.t("activerecord.errors.messages.blank"), I18n.t("activerecord.errors.messages.invalid") ],
                 transaction.errors[:date]
    assert_equal [ I18n.t("activerecord.errors.messages.blank"), I18n.t("activerecord.errors.messages.not_a_number") ],
                 transaction.errors[:amount]
  end

  test "amount must be numerical" do
    account  = random_account
    category = account.categories.first

    transaction = Transaction.new(account:  account,
                                  category: category,
                                  date:     Time.zone.now,
                                  amount:   "forty two",
                                  checked:  true,
                                  comment:  "Super comment !!!")

    assert       transaction.invalid?
    assert_equal [ I18n.t("activerecord.errors.messages.not_a_number") ], transaction.errors[:amount]
  end
end
