# == Schema Information
#
# Table name: accounts
#
#  id              :integer          not null, primary key
#  name            :string           not null
#  initial_balance :decimal(8, 2)    not null
#  created_by      :integer
#  updated_by      :integer
#  created_at      :datetime
#  updated_at      :datetime
#  hidden          :boolean          default(FALSE)
#

class Account < ActiveRecord::Base
  has_and_belongs_to_many :users, uniq: true
  has_many                :categories,    dependent: :restrict_with_error
  has_many                :transactions,  dependent: :restrict_with_error
  has_many                :schedules,     dependent: :delete_all
  has_one                 :pending_user,  foreign_key: "account_id", dependent: :destroy

  accepts_nested_attributes_for :pending_user, update_only: true

  scope :order_by_name, -> { order(name: :asc) }
  scope :active,        -> { where(hidden: false) }
  scope :excluding,     ->(account) { where.not(id: account) }

  before_validation         :format_initial_balance

  validates_presence_of     :name, :initial_balance
  validates_numericality_of :initial_balance
  #TODO validates_uniqueness_of   :name, scope: user_id


  private ######################################################################

    def format_initial_balance
      if initial_balance.present?
        self.initial_balance = initial_balance_before_type_cast.to_s.gsub(' ', '').gsub(',', '.')
      end
    end
end
