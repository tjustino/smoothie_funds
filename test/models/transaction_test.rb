# == Schema Information
#
# Table name: transactions
#
#  id          :integer          not null, primary key
#  amount      :decimal(8, 2)    not null
#  checked     :boolean          default(FALSE), not null
#  comment     :text
#  created_by  :integer
#  date        :date             not null
#  updated_by  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  account_id  :integer          not null
#  category_id :integer          not null
#  schedule_id :integer
#
# Indexes
#
#  index_transactions_on_account_id   (account_id)
#  index_transactions_on_category_id  (category_id)
#  index_transactions_on_created_by   (created_by)
#  index_transactions_on_schedule_id  (schedule_id)
#  index_transactions_on_updated_by   (updated_by)
#
# Foreign Keys
#
#  account_id   (account_id => accounts.id)
#  category_id  (category_id => categories.id)
#  created_by   (created_by => users.id)
#  schedule_id  (schedule_id => schedules.id)
#  updated_by   (updated_by => users.id)
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
    assert_equal [ I18n.t("errors.messages.blank"), I18n.t("errors.messages.inclusion") ],
                 transaction.errors[:date]
    assert_equal [ I18n.t("errors.messages.blank"), I18n.t("errors.messages.not_a_number") ],
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
    assert_equal [ I18n.t("errors.messages.not_a_number") ], transaction.errors[:amount]
  end
end
