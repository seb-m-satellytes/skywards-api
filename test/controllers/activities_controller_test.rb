require "test_helper"

class ActivitiesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @activity = activities(:one)
  end

  test "should get index" do
    get activities_url, as: :json
    assert_response :success
  end

  test "should create activity" do
    assert_difference("Activity.count") do
      post activities_url, params: { activity: { activity_type: @activity.activity_type, character_id: @activity.character_id, end_time: @activity.end_time, settlement_id: @activity.settlement_id, start_time: @activity.start_time } }, as: :json
    end

    assert_response :created
  end

  test "should show activity" do
    get activity_url(@activity), as: :json
    assert_response :success
  end

  test "should update activity" do
    patch activity_url(@activity), params: { activity: { activity_type: @activity.activity_type, character_id: @activity.character_id, end_time: @activity.end_time, settlement_id: @activity.settlement_id, start_time: @activity.start_time } }, as: :json
    assert_response :success
  end

  test "should destroy activity" do
    assert_difference("Activity.count", -1) do
      delete activity_url(@activity), as: :json
    end

    assert_response :no_content
  end
end
