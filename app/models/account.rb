# frozen_string_literal: true

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

# Account model
class Account < ApplicationRecord
  has_and_belongs_to_many :users, uniq: true
  has_many                :categories,    dependent: :restrict_with_error
  has_many                :transactions,  dependent: :restrict_with_error
  has_many                :schedules,     dependent: :delete_all
  has_one                 :pending_user,
                          foreign_key:    "account_id",
                          inverse_of:     :account,
                          dependent:    :destroy

  accepts_nested_attributes_for :pending_user, update_only: true

  scope :order_by_name, ->          { order(name: :asc) }
  scope :active,        ->          { where(hidden: false) }
  scope :excluding,     ->(account) { where.not(id: account) }

  before_validation :format_initial_balance

  validates :name,            presence: true
  validates :initial_balance, presence: true, numericality: true

  def self.to_csv
    attributes = %w[name initial_balance]

    CSV.generate(headers: true, col_sep: ";", force_quotes: true) do |csv|
      csv << attributes

      all.find_each do |account|
        csv << attributes.map { |attr| account.send(attr) }
      end
    end
  end

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
