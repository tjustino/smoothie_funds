# == Schema Information
#
# Table name: search_targets
#
#  id          :integer          not null, primary key
#  target_type :string           not null
#  created_at  :datetime
#  updated_at  :datetime
#  search_id   :integer          not null
#  target_id   :integer          not null
#
# Indexes
#
#  index_search_targets_on_search_id  (search_id)
#  index_search_targets_on_target     (target_type,target_id)
#
# Foreign Keys
#
#  search_id  (search_id => searches.id) ON DELETE => cascade
#

class SearchTarget < ApplicationRecord
  belongs_to :search
  belongs_to :target, polymorphic: true

  validates :search, presence: true
  validates :target, presence: true
end
