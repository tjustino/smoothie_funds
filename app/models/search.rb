# frozen_string_literal: true

# == Schema Information
#
# Table name: searches
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  accounts   :text             not null
#  min        :decimal(8, 2)
#  max        :decimal(8, 2)
#  before     :date
#  after      :date
#  categories :text
#  operator   :integer
#  comment    :string
#  checked    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# Search model
class Search < ApplicationRecord
  belongs_to :user

  serialize :accounts,   type: Array
  serialize :categories, type: Array

  enum operator: { comment_or_not: 0, like: 1, not_like: 2 }
  enum checked:  { checked_or_not: 0, yep: 1, nop: 2 }

  validates :accounts, presence: true
  validates :min,      numericality: true, allow_nil: true
  validates :max,      numericality: true, allow_nil: true
end
