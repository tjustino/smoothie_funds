require 'test_helper'

class ScheduleTest < ActiveSupport::TestCase
  test "should create schedule" do
    account   = @accounts.first
    category  = account.categories.first

    schedule = Schedule.new(  account:    account,
                              next_time:  DateTime.now + 5.days,
                              frequency:  13,
                              period:     "days",
                              operation_attributes: { account:  account,
                                                      amount:   666,
                                                      category: category,
                                                      comment:  nil,
                                                      checked:  false } )

    assert schedule.valid?
  end

  test "account_id, next_time, frequency and period must not be empty" do
    account   = @accounts.first
    category  = account.categories.first

    schedule = Schedule.new(operation_attributes: { account:  account,
                                                    date:     DateTime.now,
                                                    amount:   666,
                                                    category: category,
                                                    comment:  nil,
                                                    checked:  false } )

    assert schedule.invalid?

    assert_equal [I18n.translate('activerecord.errors.messages.blank')],
                                                schedule.errors[:account_id]

    assert_equal [I18n.translate('activerecord.errors.messages.blank')],
                                                schedule.errors[:next_time]

    assert_equal [I18n.translate('activerecord.errors.messages.blank')],
                                                        schedule.errors[:period]

    assert_equal [  I18n.translate('activerecord.errors.messages.blank'),
                    I18n.translate('activerecord.errors.messages.not_a_number')],
                    schedule.errors[:frequency]
  end

  test "operation must not be empty" do
    account   = @accounts.first
    category  = account.categories.first

    schedule = Schedule.new(  account:    account,
                              next_time:  DateTime.now + 5.days,
                              frequency:  13,
                              period:     "days" )

    assert schedule.invalid?

    assert_equal [I18n.translate('activerecord.errors.messages.blank')],
                                                        schedule.errors[:operation]
  end

  test "frequency must be numerical" do
    account   = @accounts.first
    category  = account.categories.first

    schedule = Schedule.new(  account:    account,
                              next_time:  DateTime.now + 5.days,
                              frequency:  "forty two",
                              period:     "days",
                              operation_attributes: { account:  account,
                                                      amount:   666,
                                                      category: category,
                                                      comment:  nil,
                                                      checked:  false } )

    assert schedule.invalid?
    assert_equal [I18n.translate('activerecord.errors.messages.not_a_number')],
                                                      schedule.errors[:frequency]
  end
end
