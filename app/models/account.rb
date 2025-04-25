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
#  created_at      :datetime
#  updated_at      :datetime
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

class Account < ApplicationRecord
  has_many :relations,    dependent: :destroy
  has_many :users,        through:   :relations

  before_destroy :ensure_not_shared

  has_many :categories,   dependent: :restrict_with_error
  has_many :transactions, dependent: :restrict_with_error
  has_many :schedules,    dependent: :destroy
  has_one  :pending_user, dependent: :destroy, inverse_of: :account

  has_many :search_targets, as: :target, dependent: :destroy
  has_many :searches, through: :search_targets

  accepts_nested_attributes_for :pending_user, update_only: true

  scope :order_by_name, ->          { order(name: :asc) }
  scope :active,        ->          { where(hidden: false) }
  scope :free_of,       ->(account) { where.not(id: account) }

  before_validation :format_initial_balance

  validates :name,            presence: true
  validates :initial_balance, presence: true, numericality: true

  def shared?
    users.count > 1
  end

  private ######################################################################

    def ensure_not_shared
      if users.count > 1
        errors.add(:base, :account_is_shared)
        throw :abort
      end
    end

    def format_initial_balance
      return if initial_balance.blank?

      self.initial_balance = initial_balance_before_type_cast.to_s
                                                             .strip
                                                             .tr_s(" ", "")
                                                             .tr_s(",", ".")
                                                             .tr_s(".", ".")
    end
end
