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

class User < ApplicationRecord
  has_and_belongs_to_many :accounts
  has_many                :categories,    through:    :accounts
  has_many                :schedules,     through:    :accounts
  has_many                :transactions,  through:    :accounts
  has_many                :searches,      dependent:  :delete_all

  validates_presence_of   :email
  validates_uniqueness_of :email
  validates_format_of     :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  validates_length_of     :password, minimum: 6, if: :password

  has_secure_password
end
