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

class Search < ActiveRecord::Base
  belongs_to  :user

  serialize :accounts,    Array
  serialize :categories,  Array

  enum operator:  [ :comment_or_not, :like,  :not_like ]
  enum checked:   [ :checked_or_not, :yep,   :nop      ]

  validates_presence_of     :user_id, :accounts
  validates_numericality_of :min, :max, allow_nil: true
end
