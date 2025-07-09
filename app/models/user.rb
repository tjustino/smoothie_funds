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
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#

class User < ApplicationRecord
  has_secure_password

  has_many :sessions,     dependent: :destroy
  has_many :relations,    dependent: :destroy
  has_many :accounts,     through:   :relations
  has_many :categories,   through:   :accounts
  has_many :schedules,    through:   :accounts
  has_many :transactions, through:   :accounts
  has_many :searches,     dependent: :destroy

  validates :email, presence: true, uniqueness: true, format: {
    with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  }
  validates :password, length: { minimum: 8 }, if: :password

  normalizes :email, with: ->(email) { email.strip.downcase }
end
