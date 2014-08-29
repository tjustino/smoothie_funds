# == Schema Information
#
# Table name: accounts
#
#  id              :integer          not null, primary key
#  name            :string(255)      not null
#  initial_balance :decimal(8, 2)    not null
#  created_by      :integer
#  updated_by      :integer
#  created_at      :datetime
#  updated_at      :datetime
#

require 'test_helper'

class AccountTest < ActiveSupport::TestCase
  test "should create account" do
    account = Account.new(name:             "My Account",
                          initial_balance:  30.11)
    assert account.valid?
  end

  test "name and initial_balance must not be empty" do
    account = Account.new
    assert account.invalid?
    assert_equal [I18n.translate('activerecord.errors.messages.blank')],
                                                            account.errors[:name]

    assert_equal [I18n.translate('activerecord.errors.messages.blank'),
                  I18n.translate('activerecord.errors.messages.not_a_number')],
                  account.errors[:initial_balance]
  end

  test "initial_balance must be numerical" do
    account = Account.new(name: "toto", initial_balance: "one")
    assert account.invalid?
    assert_equal [I18n.translate('activerecord.errors.messages.not_a_number')],
                                                account.errors[:initial_balance]
  end
end
