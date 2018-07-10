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

  validates :account_id, presence: true, uniqueness: { scope: :user_id }
  validates :user_id,    presence: true, uniqueness: { scope: :account_id }
end
