# frozen_string_literal: true

require "test_helper"

class SearchesControllerTest < ActionController::TestCase
  ############################################################ GET /searches/:id
  test "should get show" do
    get_show        some_search
    assert_response :success
  end

  ############################################# GET /users/:user_id/searches/new
  test "should get new" do
    get_new         @user
    assert_response :success
  end

  test "should not get new - hacker way" do
    get_new               @wrong_user
    assert_redirected_to  dashboard_url
  end

  test "should not get new - unknow user" do
    get_new               @unknow_user
    assert_redirected_to  dashboard_url
  end

  ################################################ POST /users/:user_id/searches
  test "should create search" do
    assert_difference("Search.count") do
      post_create           @user
    end
  end

  test "should not create more than 3 searches" do
    5.times { some_search }
    post_create @user
    assert_equal 3, @user.searches.count
  end

  test "should not create search - hacker way" do
    assert_no_difference("Search.count") do
      post_create           @wrong_user
      assert_redirected_to  dashboard_url
    end
  end

  test "should not create search - unknow user" do
    assert_no_difference("Search.count") do
      post_create           @unknow_user
      assert_redirected_to  dashboard_url
    end
  end

  ######################################################### DELETE /searches/:id
  test "should destroy search" do
    # first_search = some_search
    second_search = some_search

    assert_difference("Search.count", -1) do
      delete_destroy        second_search
      assert_redirected_to  new_user_search_url @user
      assert_equal I18n.t("searches.destroy.successfully_destroyed"), flash[:notice]
    end
  end

  test "should not destroy search - hacker way" do
    # first_wrong_search  = some_wrong_search
    second_wrong_search = some_wrong_search

    assert_no_difference "Search.count" do
      delete_destroy        second_wrong_search
      assert_redirected_to  dashboard_url
    end
  end

  # TODO: how to delete an account?
  # test "should destroy search with user" do
  #   assert_no_difference "Search.count" do
  #     delete_destroy        @some_category
  #   end
  # end

  private ######################################################################

    def some_search
      Search.create(user:       @user,
                    accounts:   id_of(@some_account),
                    min:        -500,
                    max:        500,
                    before:     3.months.since,
                    after:      3.months.ago,
                    categories: id_of(@some_category),
                    operator:   1,
                    comment:    "a",
                    checked:    0)
    end

    def some_wrong_search
      Search.create(user:       @wrong_user,
                    accounts:   id_of(@some_wrong_account),
                    min:        -500,
                    max:        500,
                    before:     3.months.since,
                    after:      3.months.ago,
                    categories: id_of(@some_wrong_category),
                    operator:   1,
                    comment:    "b",
                    checked:    0)
    end

    def get_show(search)
      get :show, params: { id: search }
    end

    def get_new(user)
      get :new, params: { user_id: user }
    end

    def post_create(user)
      post :create, params: { user_id: user, search: search_hash }
    end

    def search_hash
      { accounts:   id_of(@some_account),
        min:        rand(-500.00..0.00),
        max:        rand(0.00..500.00),
        before:     random_period_for(:before),
        after:      random_period_for(:after),
        categories: id_of(@some_category),
        operator:   %i[comment_or_not like not_like].sample,
        comment:    ("a".."z").to_a.sample,
        checked:    %i[checked_or_not yep nop].sample }
    end

    def id_of(object)
      [object.id.to_s]
    end

    def random_period_for(period)
      if    period == :before
        rand(Time.zone.now..3.months.since)
      elsif period == :after
        rand(3.months.ago..Time.zone.now)
      end
    end

    def delete_destroy(search)
      delete :destroy, params: { id: search }
    end
end
