require "test_helper"

class SettlementsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @settlement = settlements(:one)
  end

  test "should get index" do
    get settlements_url, as: :json
    assert_response :success
  end

  test "should create settlement" do
    assert_difference("Settlement.count") do
      post settlements_url, params: { settlement: { level: @settlement.level, location: @settlement.location, name: @settlement.name } }, as: :json
    end

    assert_response :created
  end

  test "should show settlement" do
    get settlement_url(@settlement), as: :json
    assert_response :success
  end

  test "should update settlement" do
    patch settlement_url(@settlement), params: { settlement: { level: @settlement.level, location: @settlement.location, name: @settlement.name } }, as: :json
    assert_response :success
  end

  test "should destroy settlement" do
    assert_difference("Settlement.count", -1) do
      delete settlement_url(@settlement), as: :json
    end

    assert_response :no_content
  end
end
