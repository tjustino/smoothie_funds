# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  account_id :integer          not null
#  name       :string           not null
#  created_by :integer
#  updated_by :integer
#  created_at :datetime
#  updated_at :datetime
#

class Category < ActiveRecord::Base
  belongs_to  :account
  has_many    :transactions, dependent: :restrict_with_error

  scope :order_by_name,       -> { order(name: :asc) }

  validates_presence_of   :name, :account_id
  validates_uniqueness_of :name, scope: :account_id
end
