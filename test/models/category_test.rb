# frozen_string_literal: true

# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  account_id :integer          not null
#  name       :string           not null
#  created_by :integer
#  updated_by :integer
#  created_at :datetime
#  updated_at :datetime
#  hidden     :boolean          default(FALSE)
#

require "test_helper"

# Category Model Test
class CategoryTest < ActiveSupport::TestCase
  test "should create category" do
    category = Category.new(account: @accounts.first,
                            name:    "My Category",
                            hidden:  true_or_false)
    assert category.valid?
  end

  test "name and account_id must not be empty" do
    category = Category.new
    assert       category.invalid?
    assert_equal [I18n.t("activerecord.errors.messages.blank")], category.errors[:name]
    assert_equal [I18n.t("activerecord.errors.messages.blank")], category.errors[:account_id]
  end

  test "name/account_id must be unique" do
    category1 = Category.create(name: "toto", account: @accounts.first, hidden: true_or_false)
    category2 = category1.dup
    category3 = Category.create(name: category1.name, account: @accounts.last, hidden: category1.hidden)

    assert       category1.valid?
    assert       category2.invalid?
    assert       category3.valid?
    assert_equal [I18n.t("activerecord.errors.messages.taken")], category2.errors[:name]
  end
end
