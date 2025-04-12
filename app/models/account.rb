# == Schema Information
#
# Table name: accounts
#
#  id              :integer          not null, primary key
#  created_by      :integer
#  hidden          :boolean          default(FALSE), not null
#  initial_balance :decimal(8, 2)    not null
#  name            :string           not null
#  updated_by      :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_accounts_on_created_by  (created_by)
#  index_accounts_on_updated_by  (updated_by)
#
# Foreign Keys
#
#  created_by  (created_by => users.id)
#  updated_by  (updated_by => users.id)
#

# Account model
class Account < ApplicationRecord
  has_many :relations,    dependent: :delete_all
  has_many :users,        through:   :relations

  has_many :categories,   dependent: :restrict_with_error
  has_many :transactions, dependent: :restrict_with_error
  has_many :schedules,    dependent: :delete_all
  has_one  :pending_user, dependent: :destroy, inverse_of: :account

  accepts_nested_attributes_for :pending_user, update_only: true

  scope :order_by_name, ->          { order(name: :asc) }
  scope :active,        ->          { where(hidden: false) }
  scope :free_of,       ->(account) { where.not(id: account) }

  before_validation :format_initial_balance

  validates :name,            presence: true
  validates :initial_balance, presence: true, numericality: true

  private ######################################################################

    def format_initial_balance
      return if initial_balance.blank?

      self.initial_balance = initial_balance_before_type_cast.to_s
                                                             .strip
                                                             .tr_s(" ", "")
                                                             .tr_s(",", ".")
                                                             .tr_s(".", ".")
    end
end
