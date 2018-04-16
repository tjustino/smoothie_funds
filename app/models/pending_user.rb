# frozen_string_literal: true

# == Schema Information
#
# Table name: pending_users
#
#  id         :integer          not null, primary key
#  account_id :integer          not null
#  email      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# PendingUser model
class PendingUser < ApplicationRecord
  belongs_to :account

  validates :account_id, uniqueness: true
  validates :email,      presence: true
  validates :account_id, presence: true
  validates :email,      format: {
    with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  }
end
