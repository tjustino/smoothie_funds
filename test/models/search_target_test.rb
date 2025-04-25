# == Schema Information
#
# Table name: search_targets
#
#  id          :integer          not null, primary key
#  target_type :string           not null
#  created_at  :datetime
#  updated_at  :datetime
#  search_id   :integer          not null
#  target_id   :integer          not null
#
# Indexes
#
#  index_search_targets_on_search_id  (search_id)
#  index_search_targets_on_target     (target_type,target_id)
#
# Foreign Keys
#
#  search_id  (search_id => searches.id) ON DELETE => cascade
#

require "test_helper"

class SearchTargetTest < ActiveSupport::TestCase
  test "is valid with a polymorphic target" do
    user = :thomas
    search = Search.where(user_id: users(user)).sample
    account = some_account_for(user)
    search_target = SearchTarget.new(search: search, target: account)

    assert search_target.valid?
  end

  test "is invalid without search and target" do
    search_target = SearchTarget.new

    assert          search_target.invalid?
    assert_includes search_target.errors[:search],
                    I18n.t("activerecord.errors.models.search_target.attributes.search.required")
    assert_includes search_target.errors[:target],
                    I18n.t("activerecord.errors.models.search_target.attributes.target.required")
  end
end
