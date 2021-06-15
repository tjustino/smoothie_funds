# frozen_string_literal: true

# Old categories can be hidden
class AddHiddenToCategory < ActiveRecord::Migration[6.1]
  def change
    add_column :categories, :hidden, :boolean, default: false
  end
end
