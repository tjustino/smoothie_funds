# frozen_string_literal: true

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
#  hidden     :boolean          default(FALSE)
#

# Category model
class Category < ApplicationRecord
  belongs_to  :account
  has_many    :transactions, dependent: :restrict_with_error

  scope :order_by_name, -> { order(name: :asc) }
  scope :active,        -> { where(hidden: false) }

  validates :name, presence: true, uniqueness: { scope: :account_id }
end
