# == Schema Information
#
# Table name: sessions
#
#  id         :integer          not null, primary key
#  ip_address :string
#  user_agent :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer          not null
#
# Indexes
#
#  index_sessions_on_user_id  (user_id)
#
# Foreign Keys
#
#  user_id  (user_id => users.id)
#

require "test_helper"

class SessionTest < ActiveSupport::TestCase
  setup do
    @ip_address = "127.0.0.1"
    @user_agent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:140.0) Gecko/20100101 Firefox/140.0"
  end

  test "should create session" do
    session = Session.new ip_address: @ip_address, user_agent: @user_agent, user_id: users(:thomas).id

    assert session.valid?
  end

  test "user_id must not be empty" do
    session = Session.new ip_address: @ip_address, user_agent: @user_agent

    assert       session.invalid?
    assert_equal [ I18n.t("errors.messages.blank") ], session.errors[:user_id]
  end

  test "user_id must exist" do
    session = Session.new ip_address: @ip_address, user_agent: @user_agent, user_id: User.maximum(:id) + 1

    assert       session.invalid?
    assert_equal [ I18n.t("activerecord.errors.models.session.attributes.user.required") ], session.errors[:user]
  end
end
