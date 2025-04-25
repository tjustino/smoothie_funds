# == Schema Information
#
# Table name: searches
#
#  id         :integer          not null, primary key
#  after      :date
#  before     :date
#  checked    :integer
#  comment    :string
#  max        :decimal(8, 2)
#  min        :decimal(8, 2)
#  operator   :integer
#  created_at :datetime
#  updated_at :datetime
#  user_id    :integer          not null
#
# Indexes
#
#  index_searches_on_user_id  (user_id)
#
# Foreign Keys
#
#  user_id  (user_id => users.id)
#

require "test_helper"

class SearchTest < ActiveSupport::TestCase
  test "should create search" do
    user = :thomas
    account_ids = some_accounts_for(user)
    category_ids = some_categories_for(account_ids)
    search_targets_attributes = []
    account_ids.each { |account_id| search_targets_attributes << { target_type: "Account", target_id: account_id } }
    category_ids.each { |category_id| search_targets_attributes << { target_type: "Category", target_id: category_id } }
    search = Search.new(user:       users(user),
                        min:        -500,
                        max:        500,
                        before:     3.months.since,
                        after:      3.months.ago,
                        operator:   1,
                        comment:    "a",
                        checked:    0,
                        search_targets_attributes: search_targets_attributes)

    assert search.valid?
  end

  test "user_id, accounts and categories must not be empty" do
    search = Search.new

    assert          search.invalid?
    assert_includes search.errors[:user], I18n.t("activerecord.errors.models.search.attributes.user.required")
    assert_includes search.errors[:base], I18n.t("activerecord.errors.models.search.attributes.base.missing_account")
    assert_includes search.errors[:base], I18n.t("activerecord.errors.models.search.attributes.base.missing_category")
  end

  test "min and max must be numerical" do
    user = :thomas
    accounts = some_accounts_for(user)
    search = Search.new(user:       users(user),
                        min:        "one",
                        max:        "ten",
                        before:     3.months.since,
                        after:      3.months.ago,
                        operator:   1,
                        comment:    "a",
                        checked:    0,
                        search_targets_attributes: [
                          { target_type: "Account", target_id: accounts },
                          { target_type: "Category", target_id: some_categories_for(accounts) }
                        ])

    assert       search.invalid?
    assert_equal [ I18n.t("errors.messages.not_a_number") ], search.errors[:min]
    assert_equal [ I18n.t("errors.messages.not_a_number") ], search.errors[:max]
  end
end
