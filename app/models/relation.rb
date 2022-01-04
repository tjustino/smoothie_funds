# frozen_string_literal: true

# == Schema Information
#
# Table name: relations
#
#  account_id :integer          not null
#  user_id    :integer          not null
#  created_at :datetime
#  updated_at :datetime
#

# Relation model
class Relation < ApplicationRecord
  belongs_to :account
  belongs_to :user

  scope :shared_accounts, ->(accounts) {
    select(:account_id).where(account_id: accounts).group(:account_id).having("COUNT(user_id) > 1")
  }
  scope :not_shared_accounts, ->(accounts) {
    select(:account_id).where(account_id: accounts).group(:account_id).having("COUNT(user_id) = 1")
  }

  validates :account_id, uniqueness: { scope: :user_id }
  validates :user_id,    uniqueness: { scope: :account_id }
end
