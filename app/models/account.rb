# == Schema Information
#
# Table name: accounts
#
#  id              :integer          not null, primary key
#  name            :string(255)      not null
#  initial_balance :decimal(8, 2)    not null
#  created_by      :integer
#  updated_by      :integer
#  created_at      :datetime
#  updated_at      :datetime
#

class Account < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many                :categories,    dependent: :restrict_with_error
  has_many                :transactions,  dependent: :restrict_with_error
  has_many                :schedules,     dependent: :delete_all

  validates_presence_of     :name, :initial_balance
  validates_numericality_of :initial_balance
  #validates_uniqueness_of   :name, scope: :user_id

  #scope :active,       -> { where(active: true) }
  scope :order_by_name, -> { order(name: :asc) }
end
