# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  created_by :integer
#  hidden     :boolean          default(FALSE), not null
#  name       :string           not null
#  updated_by :integer
#  created_at :datetime
#  updated_at :datetime
#  account_id :integer          not null
#
# Indexes
#
#  index_categories_on_account_id           (account_id)
#  index_categories_on_account_id_and_name  (account_id,name) UNIQUE
#  index_categories_on_created_by           (created_by)
#  index_categories_on_updated_by           (updated_by)
#
# Foreign Keys
#
#  account_id  (account_id => accounts.id)
#  created_by  (created_by => users.id)
#  updated_by  (updated_by => users.id)
#

require "test_helper"

# Category Model Test
class CategoryTest < ActiveSupport::TestCase
  test "should create category" do
    category = Category.new(account: random_account,
                            name:    "My Category",
                            hidden:  true_or_false)

    assert category.valid?
  end

  test "name and account_id must not be empty" do
    category = Category.new

    assert       category.invalid?
    assert_equal [ I18n.t("activerecord.errors.models.category.attributes.account.required") ], category.errors[:account]
    assert_equal [ I18n.t("errors.messages.blank") ], category.errors[:name]
  end

  test "name/account_id must be unique" do
    rand_account = random_account
    category1 = Category.create(name: "toto", account: rand_account, hidden: true_or_false)
    category2 = category1.dup
    category3 = Category.create(name: category1.name, account: another(rand_account), hidden: category1.hidden)

    assert       category1.valid?
    assert       category2.invalid?
    assert       category3.valid?
    assert_equal [ I18n.t("activerecord.errors.messages.taken") ], category2.errors[:name]
  end
end
