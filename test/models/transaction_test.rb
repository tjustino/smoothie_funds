require 'test_helper'

class TransactionTest < ActiveSupport::TestCase
  test "should create transaction" do
    account   = @accounts.first
    category  = account.categories.first

    transaction = Transaction.new(account:  account,
                                  category: category,
                                  date:     DateTime.now,
                                  amount:   42,
                                  checked:  true,
                                  comment:  "Super comment !!!")
    assert transaction.valid?
  end

  test "account_id, category_id, date and amount must not be empty" do
    transaction = Transaction.new
    assert transaction.invalid?
    assert_equal [I18n.translate('activerecord.errors.messages.blank')],
                                                transaction.errors[:account_id]

    assert_equal [I18n.translate('activerecord.errors.messages.blank')],
                                                transaction.errors[:category_id]

    assert_equal [I18n.translate('activerecord.errors.messages.blank')],
                                                        transaction.errors[:date]

    assert_equal [  I18n.translate('activerecord.errors.messages.blank'),
                    I18n.translate('activerecord.errors.messages.not_a_number')],
                    transaction.errors[:amount]
  end

  test "amount must be numerical" do
    account   = @accounts.first
    category  = account.categories.first

    transaction = Transaction.new(account:  account,
                                  category: category,
                                  date:     DateTime.now,
                                  amount:   "forty two",
                                  checked:  true,
                                  comment:  "Super comment !!!")
    assert transaction.invalid?
    assert_equal [I18n.translate('activerecord.errors.messages.not_a_number')],
                                                      transaction.errors[:amount]
  end
end
