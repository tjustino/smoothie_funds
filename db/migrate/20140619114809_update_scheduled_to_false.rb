class UpdateScheduledToFalse < ActiveRecord::Migration
  def up
    Transaction.all.each do |transaction|
      transaction.scheduled = false
      transaction.save!
    end
  end

  def down
    Transaction.all.each do |transaction|
      transaction.scheduled = nil
      transaction.save!
    end
  end
end
