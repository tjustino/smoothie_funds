# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string           not null
#  name            :string
#  password_digest :string
#  created_at      :datetime
#  updated_at      :datetime
#

# User model
class User < ApplicationRecord
  has_and_belongs_to_many :accounts
  has_many                :categories,    through:    :accounts
  has_many                :schedules,     through:    :accounts
  has_many                :transactions,  through:    :accounts
  has_many                :searches,      dependent:  :delete_all

  validates :email, presence: true, uniqueness: true, format: {
    with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  }
  validates :password, length: { minimum: 6 }, if: :password

  has_secure_password
end
