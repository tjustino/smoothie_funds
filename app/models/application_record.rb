# frozen_string_literal: true

# Implement an ActiveRecord model as an abstract class
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.to_csv(attributes)
    CSV.generate(headers: true, col_sep: ";", force_quotes: true) do |csv|
      csv << attributes

      find_each do |account|
        csv << attributes.map { |attr| account.send(attr) }
      end
    end
  end
end
