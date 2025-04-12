# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  created_by :integer
#  hidden     :boolean          default(FALSE), not null
#  name       :string           not null
#  updated_by :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
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

# Category model
class Category < ApplicationRecord
  belongs_to  :account
  has_many    :transactions, dependent: :restrict_with_error

  scope :order_by_name, -> { order(name: :asc) }
  scope :active,        -> { where(hidden: false) }

  validates :name, presence: true, uniqueness: { scope: :account_id }
end
