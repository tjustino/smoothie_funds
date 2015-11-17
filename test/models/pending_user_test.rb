# == Schema Information
#
# Table name: pending_users
#
#  id         :integer          not null, primary key
#  account_id :integer          not null
#  email      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class PendingUserTest < ActiveSupport::TestCase
  test "should create pending user" do
    pending_user = PendingUser.new( account:  @some_account,
                                    email:    "user@domain.tld")
    assert pending_user.valid?
  end

  test "account must be unique" do
    pending_user = PendingUser.new( account_id: @some_pending_user.account_id,
                                    email:      "user@domain.tld")
    assert        pending_user.invalid?
    assert_equal  [ I18n.translate('activerecord.errors.messages.taken') ], 
                  pending_user.errors[:account_id]
  end

  test "email and account_id must be present" do
    pending_user = PendingUser.new
    assert        pending_user.invalid?
    assert_equal  [ I18n.translate('activerecord.errors.messages.blank'), 
                    I18n.translate('activerecord.errors.messages.invalid') ],
                  pending_user.errors[:email]
    assert_equal  [ I18n.translate('activerecord.errors.messages.blank') ],
                  pending_user.errors[:account_id]
  end

  test "email must be valid" do
    pending_user1 = PendingUser.new(account: @some_account, email: "username@domain")
    assert        pending_user1.invalid?
    assert_equal  [I18n.translate('activerecord.errors.messages.invalid')], pending_user1.errors[:email]

    pending_user2 = PendingUser.new(account: @some_account, email: "@domain.tld")
    assert        pending_user2.invalid?
    assert_equal  [I18n.translate('activerecord.errors.messages.invalid')], pending_user2.errors[:email]

    pending_user3 = PendingUser.new(account: @some_account, email: "username#domain.tld")
    assert        pending_user3.invalid?
    assert_equal  [I18n.translate('activerecord.errors.messages.invalid')], pending_user3.errors[:email]
  end
end
