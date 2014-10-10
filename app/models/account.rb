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
  has_and_belongs_to_many :users, uniq: true
  has_many                :categories,    dependent: :restrict_with_error
  has_many                :transactions,  dependent: :restrict_with_error
  has_many                :schedules,     dependent: :delete_all

  before_validation :format_initial_balance

  validates_presence_of     :name, :initial_balance
  validates_numericality_of :initial_balance
  #TODO validates_uniqueness_of   :name, scope: user_id

  scope :order_by_name, -> { order(name: :asc) }
  #scope :active,       -> { where(active: true) }


  private ######################################################################

    def format_initial_balance
      self.initial_balance = initial_balance_before_type_cast.gsub(' ', '').gsub(',', '.')
    end
end
