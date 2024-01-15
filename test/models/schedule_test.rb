# frozen_string_literal: true

# == Schema Information
#
# Table name: schedules
#
#  id         :integer          not null, primary key
#  account_id :integer          not null
#  next_time  :date             not null
#  frequency  :integer          not null
#  period     :string           not null
#  created_by :integer
#  updated_by :integer
#  created_at :datetime
#  updated_at :datetime
#

require "test_helper"

# Schedule Model Test
class ScheduleTest < ActiveSupport::TestCase
  test "should create schedule" do
    account  = random_account
    category = account.categories.first

    schedule = Schedule.new(account:              account,
                            next_time:            5.days.from_now,
                            frequency:            13,
                            period:               "days",
                            operation_attributes: { account:  account,
                                                    amount:   666,
                                                    category: category,
                                                    comment:  nil,
                                                    checked:  false })

    assert schedule.valid?
  end

  test "account_id, next_time, frequency and period must not be empty" do
    account  = random_account
    category = account.categories.first

    schedule = Schedule.new(operation_attributes: { account:  account,
                                                    date:     Time.zone.now,
                                                    amount:   666,
                                                    category: category,
                                                    comment:  nil,
                                                    checked:  false })

    assert       schedule.invalid?
    assert_equal [ I18n.t("activerecord.errors.models.schedule.attributes.account.required") ], schedule.errors[:account]
    assert_equal [ I18n.t("activerecord.errors.messages.blank") ], schedule.errors[:next_time]
    assert_equal [ I18n.t("activerecord.errors.messages.blank") ], schedule.errors[:period]
    assert_equal [ I18n.t("activerecord.errors.messages.blank"), I18n.t("activerecord.errors.messages.not_a_number") ],
                 schedule.errors[:frequency]
  end

  test "operation must not be empty" do
    account = random_account

    schedule = Schedule.new(account:   account,
                            next_time: 5.days.from_now,
                            frequency: 13,
                            period:    "days")

    assert       schedule.invalid?
    assert_equal [ I18n.t("activerecord.errors.messages.blank") ], schedule.errors[:operation]
  end

  test "frequency must be numerical" do
    account  = random_account
    category = account.categories.first

    schedule = Schedule.new(account:              account,
                            next_time:            5.days.from_now,
                            frequency:            "forty two",
                            period:               "days",
                            operation_attributes: { account:  account,
                                                    amount:   666,
                                                    category: category,
                                                    comment:  nil,
                                                    checked:  false })

    assert       schedule.invalid?
    assert_equal [ I18n.t("activerecord.errors.messages.not_a_number") ], schedule.errors[:frequency]
  end
end
