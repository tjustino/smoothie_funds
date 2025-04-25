# == Schema Information
#
# Table name: relations
#
#  id         :integer          not null, primary key
#  created_at :datetime
#  updated_at :datetime
#  account_id :integer          not null
#  user_id    :integer          not null
#
# Indexes
#
#  index_relations_on_account_id              (account_id)
#  index_relations_on_user_id                 (user_id)
#  index_relations_on_user_id_and_account_id  (user_id,account_id) UNIQUE
#
# Foreign Keys
#
#  account_id  (account_id => accounts.id)
#  user_id     (user_id => users.id)
#
require "test_helper"

class RelationTest < ActiveSupport::TestCase
  test "should not allow duplicate user ↔ account relation" do
    duplicated_relation = Relation.first.dup

    assert          duplicated_relation.invalid?
    assert_includes duplicated_relation.errors[:account_id], I18n.t("activerecord.errors.messages.taken")
  end
end
