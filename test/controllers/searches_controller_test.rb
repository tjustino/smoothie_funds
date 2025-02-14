# frozen_string_literal: true

require "test_helper"

# Searches Controller Test
class SearchesControllerTest < ActionDispatch::IntegrationTest
  setup { login_as :thomas }

  #################################################################################################### GET /searches/:id
  test "should get show" do
    get "/searches/#{some_search_for(:thomas).id}"

    assert_response :success
  end

  ##################################################################################### GET /users/:user_id/searches/new
  test "should get new" do
    get_new :thomas

    assert_response :success
  end

  test "should not get new - hacker way" do
    get_new :emilie

    assert_redirected_to dashboard_url
  end

  test "should not get new - unknow user" do
    get "/users/#{User.maximum(:id) + 1}/searches/new"

    assert_redirected_to dashboard_url
  end

  ######################################################################################## POST /users/:user_id/searches
  test "should create search" do
    assert_difference("Search.count") { post_create :thomas }
  end

  test "should not create more than 3 searches" do
    5.times { some_search_for(:thomas) }
    post_create :thomas

    assert_equal 3, users(:thomas).searches.count
  end

  test "should not create search - hacker way" do
    assert_no_difference("Search.count") do
      post_create :emilie

      assert_redirected_to dashboard_url
    end
  end

  test "should not create search - unknow user" do
    assert_no_difference("Search.count") do
      post "/users/#{User.maximum(:id) + 1}/searches",
           params: { search: { accounts:   Account.first,
                               min:        rand(-500.00..0.00),
                               max:        rand(0.00..500.00),
                               before:     random_period_for(:before),
                               after:      random_period_for(:after),
                               categories: some_categories_for(Account.first),
                               operator:   %i[comment_or_not like unlike].sample,
                               comment:    ("a".."z").to_a.sample,
                               checked:    %i[checked_or_not yep nop].sample } }

      assert_redirected_to dashboard_url
    end
  end

  ################################################################################################# DELETE /searches/:id
  test "should destroy search" do
    user = :thomas
    some_search = some_search_for(user)

    assert_difference("Search.count", -1) do
      delete_destroy some_search

      assert_redirected_to new_user_search_url(users(user))
      assert_equal         I18n.t("searches.destroy.successfully_destroyed"), flash[:notice]
    end
  end

  test "should not destroy search - hacker way" do
    some_wrong_search = some_search_for(:emilie)

    assert_no_difference "Search.count" do
      delete_destroy some_wrong_search

      assert_redirected_to dashboard_url
    end
  end

  private ##############################################################################################################

    def some_search_for(user)
      accounts = some_accounts_for(user)
      Search.create(user:       users(user),
                    accounts:   accounts,
                    min:        -500,
                    max:        500,
                    before:     3.months.since,
                    after:      3.months.ago,
                    categories: some_categories_for(accounts),
                    operator:   1,
                    comment:    "a",
                    checked:    0)
    end

    def get_new(user)
      get "/users/#{users(user).id}/searches/new"
    end

    def post_create(user)
      accounts = some_accounts_for(user)
      post "/users/#{users(user).id}/searches", params: { search: { accounts:   accounts,
                                                                    min:        rand(-500.00..0.00),
                                                                    max:        rand(0.00..500.00),
                                                                    before:     random_period_for(:before),
                                                                    after:      random_period_for(:after),
                                                                    categories: some_categories_for(accounts),
                                                                    operator:   %i[comment_or_not like unlike].sample,
                                                                    comment:    ("a".."z").to_a.sample,
                                                                    checked:    %i[checked_or_not yep nop].sample } }
    end

    def random_period_for(period)
      case period
      when :before
        rand(Time.zone.now..3.months.since)
      when :after
        rand(3.months.ago..Time.zone.now)
      end
    end

    def delete_destroy(search)
      delete "/searches/#{search.id}"
    end
end
