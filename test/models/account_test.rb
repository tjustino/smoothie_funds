# frozen_string_literal: true

# == Schema Information
#
# Table name: accounts
#
#  id              :integer          not null, primary key
#  name            :string           not null
#  initial_balance :decimal(8, 2)    not null
#  created_by      :integer
#  updated_by      :integer
#  created_at      :datetime
#  updated_at      :datetime
#  hidden          :boolean          default(FALSE)
#

require "test_helper"

# Account Model Test
class AccountTest < ActiveSupport::TestCase
  test "should create account" do
    account = Account.new(name:            "Crazy Account",
                          initial_balance: 30.11,
                          hidden:          false)
    assert account.valid?
  end

  test "format initial balance" do
    account = Account.new(name:            "Crazy initial balance Account",
                          initial_balance: "1 234,56",
                          hidden:          false)

    assert          account.valid?
    assert_in_delta 1234.56, account.initial_balance
  end

  test "name and initial_balance must not be empty" do
    account = Account.new
    assert account.invalid?
    assert_equal [I18n.t("activerecord.errors.messages.blank")], account.errors[:name]

    assert_equal [I18n.t("activerecord.errors.messages.blank"), I18n.t("activerecord.errors.messages.not_a_number")],
                 account.errors[:initial_balance]
  end

  test "initial_balance must be numerical" do
    account = Account.new(name: "toto", initial_balance: "one")
    assert account.invalid?
    assert_equal [I18n.t("activerecord.errors.messages.not_a_number")], account.errors[:initial_balance]
  end
end
