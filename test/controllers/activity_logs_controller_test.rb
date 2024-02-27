require "test_helper"

class ActivityLogsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @activity_log = activity_logs(:one)
  end

  test "should get index" do
    get activity_logs_url, as: :json
    assert_response :success
  end

  test "should create activity_log" do
    assert_difference("ActivityLog.count") do
      post activity_logs_url, params: { activity_log: { description: @activity_log.description } }, as: :json
    end

    assert_response :created
  end

  test "should show activity_log" do
    get activity_log_url(@activity_log), as: :json
    assert_response :success
  end

  test "should update activity_log" do
    patch activity_log_url(@activity_log), params: { activity_log: { description: @activity_log.description } }, as: :json
    assert_response :success
  end

  test "should destroy activity_log" do
    assert_difference("ActivityLog.count", -1) do
      delete activity_log_url(@activity_log), as: :json
    end

    assert_response :no_content
  end
end
