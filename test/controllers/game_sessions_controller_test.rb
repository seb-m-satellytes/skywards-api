require "test_helper"

class GameSessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @game_session = game_sessions(:one)
  end

  test "should get index" do
    get game_sessions_url, as: :json
    assert_response :success
  end

  test "should create game_session" do
    assert_difference("GameSession.count") do
      post game_sessions_url, params: { game_session: { in_game_minutes: @game_session.in_game_minutes, start_time: @game_session.start_time } }, as: :json
    end

    assert_response :created
  end

  test "should show game_session" do
    get game_session_url(@game_session), as: :json
    assert_response :success
  end

  test "should update game_session" do
    patch game_session_url(@game_session), params: { game_session: { in_game_minutes: @game_session.in_game_minutes, start_time: @game_session.start_time } }, as: :json
    assert_response :success
  end

  test "should destroy game_session" do
    assert_difference("GameSession.count", -1) do
      delete game_session_url(@game_session), as: :json
    end

    assert_response :no_content
  end
end
