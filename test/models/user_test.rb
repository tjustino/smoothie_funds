# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string           not null
#  name            :string
#  password_digest :string
#  created_at      :datetime
#  updated_at      :datetime
#

require "test_helper"

# User Model Test
class UserTest < ActiveSupport::TestCase
  test "should create user" do
    user = User.new(email:                 "random@email.com",
                    name:                  "John Doe",
                    password:              "password",
                    password_confirmation: "password")

    assert user.valid?
  end

  test "email and name must not be empty" do
    user = User.new

    assert       user.invalid?
    assert_equal [I18n.t("activerecord.errors.messages.blank"), I18n.t("activerecord.errors.messages.invalid")],
                 user.errors[:email]
  end

  test "email must be unique" do
    user = User.new(email:                 users(:thomas).email,
                    name:                  "Super Name",
                    password:              "yopmail",
                    password_confirmation: "yopmail")

    assert       user.invalid?
    assert_equal [I18n.t("activerecord.errors.messages.taken")], user.errors[:email]
  end

  test "email must be valid" do
    user1 = User.new(email:                 "username@domain",
                     password:              "p@ssw0rd!",
                     password_confirmation: "p@ssw0rd!")

    assert       user1.invalid?
    assert_equal [I18n.t("activerecord.errors.messages.invalid")], user1.errors[:email]

    user2 = User.new(email:                 "@domain.tld",
                     password:              "p@ssw0rd!",
                     password_confirmation: "p@ssw0rd!")

    assert       user2.invalid?
    assert_equal [I18n.t("activerecord.errors.messages.invalid")], user2.errors[:email]

    user3 = User.new(email:                 "username#domain.tld",
                     password:              "p@ssw0rd!",
                     password_confirmation: "p@ssw0rd!")

    assert       user3.invalid?
    assert_equal [I18n.t("activerecord.errors.messages.invalid")], user3.errors[:email]
  end

  test "the password must be at least 8 characters long" do
    user = User.new(email:                 users(:thomas).email,
                    name:                  "Too Short",
                    password:              "short",
                    password_confirmation: "short")

    assert       user.invalid?
    assert_equal [I18n.t("activerecord.errors.messages.too_short", count: 8)], user.errors[:password]
  end
end
