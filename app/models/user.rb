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

class User < ActiveRecord::Base
  has_and_belongs_to_many :accounts
  has_many                :searches, dependent: :delete_all

  validates_presence_of   :email
  validates_uniqueness_of :email
  validates_length_of     :password, minimum: 6, if: :password

  has_secure_password
end
