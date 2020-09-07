# frozen_string_literal: true

# == Schema Information
#
# Table name: searches
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  accounts   :text             not null
#  min        :decimal(8, 2)
#  max        :decimal(8, 2)
#  before     :date
#  after      :date
#  categories :text
#  operator   :integer
#  comment    :string
#  checked    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require "test_helper"

# Search Model Test
class SearchTest < ActiveSupport::TestCase
  test "should create search" do
    search = Search.new(user:       @user,
                        accounts:   [@some_account.id.to_s],
                        min:        -500,
                        max:        500,
                        before:     3.months.since,
                        after:      3.months.ago,
                        categories: [@some_category.id.to_s],
                        operator:   1,
                        comment:    "a",
                        checked:    0)
    assert search.valid?
  end

  test "user_id and accounts must not be empty" do
    search = Search.new
    assert search.invalid?
    assert_equal [I18n.t("activerecord.errors.messages.blank")], search.errors[:user_id]
    assert_equal [I18n.t("activerecord.errors.messages.blank")], search.errors[:accounts]
  end

  test "min and max must be numerical" do
    search = Search.new(user:       @user,
                        accounts:   [@some_account.id.to_s],
                        min:        "one",
                        max:        "ten",
                        before:     3.months.since,
                        after:      3.months.ago,
                        categories: [@some_category.id.to_s],
                        operator:   1,
                        comment:    "a",
                        checked:    0)
    assert search.invalid?
    assert_equal [I18n.t("activerecord.errors.messages.not_a_number")], search.errors[:min]
    assert_equal [I18n.t("activerecord.errors.messages.not_a_number")], search.errors[:max]
  end
end
