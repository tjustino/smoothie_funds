# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string(255)      not null
#  name            :string(255)      not null
#  password_digest :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#

class User < ActiveRecord::Base
  has_and_belongs_to_many :accounts

  validates_presence_of   :email, :name
  validates_uniqueness_of :email
  validates_length_of     :password, minimum: 6

  has_secure_password
end
