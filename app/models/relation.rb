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

class Relation < ApplicationRecord
  belongs_to :account
  belongs_to :user

  scope :shared_accounts, ->(accounts) {
    where(account_id: accounts).group(:account_id).having("COUNT(user_id) > 1")
  }
  scope :not_shared_accounts, ->(accounts) {
    where(account_id: accounts).group(:account_id).having("COUNT(user_id) = 1")
  }

  validates :account_id, uniqueness: { scope: :user_id }
end
