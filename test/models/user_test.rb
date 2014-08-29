# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string(255)      not null
#  name            :string(255)      not null
#  password_digest :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "should create user" do
    user = User.new(email:                  "random@email.com",
                    name:                   "John Doe",
                    password:               "password",
                    password_confirmation:  "password")
    assert user.valid?
  end

  test "email and name must not be empty" do
    user = User.new
    assert user.invalid?
    assert_equal [I18n.translate('activerecord.errors.messages.blank')], user.errors[:email]
    assert_equal [I18n.translate('activerecord.errors.messages.blank')], user.errors[:name]
  end

  test "email must be unique" do
    user = User.new(email:                  users(:thomas).email,
                    name:                   "Super Name",
                    password:               "yopmail",
                    password_confirmation:  "yopmail")
    assert user.invalid?
    assert_equal [I18n.translate('activerecord.errors.messages.taken')], user.errors[:email]
  end

  test "the password must be at least 6 characters long" do
    user = User.new(email:                  users(:thomas).email,
                    name:                   "Too Short",
                    password:               "short",
                    password_confirmation:  "short")
    assert user.invalid?
    assert_equal [I18n.translate('activerecord.errors.messages.too_short', count: 6)], user.errors[:password]
  end
end
