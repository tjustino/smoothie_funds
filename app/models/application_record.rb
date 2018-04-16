# frozen_string_literal: true

# Implement an ActiveRecord model as an abstract class
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
