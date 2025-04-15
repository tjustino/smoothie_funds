# == Schema Information
#
# Table name: pending_users
#
#  id         :integer          not null, primary key
#  email      :string           not null
#  created_at :datetime
#  updated_at :datetime
#  account_id :integer          not null
#
# Indexes
#
#  index_pending_users_on_account_id  (account_id) UNIQUE
#
# Foreign Keys
#
#  account_id  (account_id => accounts.id)
#

class PendingUser < ApplicationRecord
  belongs_to :account

  # TODO: if account_id+email already exist in relation, crash after validation
  validates :account_id, uniqueness: true
  validates :email,      presence: true
  validates :email,      format: {
    with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  }
end
