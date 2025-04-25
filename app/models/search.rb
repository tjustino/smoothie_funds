# == Schema Information
#
# Table name: searches
#
#  id         :integer          not null, primary key
#  after      :date
#  before     :date
#  checked    :integer
#  comment    :string
#  max        :decimal(8, 2)
#  min        :decimal(8, 2)
#  operator   :integer
#  created_at :datetime
#  updated_at :datetime
#  user_id    :integer          not null
#
# Indexes
#
#  index_searches_on_user_id  (user_id)
#
# Foreign Keys
#
#  user_id  (user_id => users.id)
#

class Search < ApplicationRecord
  belongs_to :user

  # polymorphic search for accounts and categories
  has_many :search_targets, dependent: :destroy
  has_many :accounts,   through: :search_targets, source: :target, source_type: "Account"
  has_many :categories, through: :search_targets, source: :target, source_type: "Category"
  accepts_nested_attributes_for :search_targets, allow_destroy: true,
    reject_if: ->(attributes) { attributes["target_id"].blank? || attributes["target_type"].blank? }

  enum :operator, [ :comment_or_not, :like, :unlike ]
  enum :checked,  [ :checked_or_not, :yep,  :nop ]

  validates :min, numericality: true, allow_nil: true
  validates :max, numericality: true, allow_nil: true

  validate :must_have_account_and_category

  private

    def must_have_account_and_category
      types = search_targets.reject(&:marked_for_destruction?).map(&:target_type)
      errors.add(:base, :missing_account)  unless types.include?("Account")
      errors.add(:base, :missing_category) unless types.include?("Category")
    end
end
