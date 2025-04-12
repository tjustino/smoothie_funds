# == Schema Information
#
# Table name: searches
#
#  id         :integer          not null, primary key
#  accounts   :text             not null
#  after      :date
#  before     :date
#  categories :text
#  checked    :integer
#  comment    :string
#  max        :decimal(8, 2)
#  min        :decimal(8, 2)
#  operator   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
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

# Search model
class Search < ApplicationRecord
  belongs_to :user

  serialize :accounts,   coder: YAML, type: Array
  serialize :categories, coder: YAML, type: Array

  enum :operator, [ :comment_or_not, :like, :unlike ]
  enum :checked,  [ :checked_or_not, :yep,  :nop ]

  validates :accounts, presence: true
  validates :min,      numericality: true, allow_nil: true
  validates :max,      numericality: true, allow_nil: true
end
