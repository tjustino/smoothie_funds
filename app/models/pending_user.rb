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

class PendingUser < ActiveRecord::Base
  belongs_to  :account

  validates_uniqueness_of :account_id
  validates_presence_of   :email, :account_id
  validates_format_of     :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
end
