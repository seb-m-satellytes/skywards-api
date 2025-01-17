class GameSessionsController < ApplicationController
  before_action :set_game_session, only: %i[ show update destroy ]

  # GET /game_sessions
  def index
    @game_sessions = GameSession.all

    render json: @game_sessions
  end

  # GET /game_sessions/1
  def show
    GameSession.first.tick
    GameSession.first.do_events

    @game_session = GameSession.includes(
      settlements: [
        characters: [
          :activities, 
          :resources, 
          :status_effects
        ], 
        resources: [], 
        buildings: [], 
        slots: [],
        activities: []
        ]).find(params[:id])

    settlements_data = @game_session.settlements.as_json(
      include: { 
        activities: [],
        characters: { 
          include: [
            :resources,
          ], 
          methods: [
            :filtered_game_events_last_minutes,
            :can_go_on_activity, 
            :current_activity,
            :current_status_effect
          ]
        },
        resources: [], 
        slots: {
          only: [:settlement_slot_id, :building_id, :usable]
        },
        buildings: {
          only: [:id, :name, :building_type, :status]
        },
      },
      methods: [
        :max_building_slots, 
        :available_slots, 
        :clearable_slots, 
        :total_housing_capacity,
        :filtered_game_events_last_minutes
      ]
    )

    render json: {
      game_session: @game_session.as_json,
      current_day: @game_session.current_day,
      current_time: @game_session.current_time,
      settlements: settlements_data
    }
  end

  # POST /game_sessions
  def create
    @game_session = GameSession.new(game_session_params)

    if @game_session.save
      render json: @game_session, status: :created, location: @game_session
    else
      render json: @game_session.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /game_sessions/1
  def update
    if @game_session.update(game_session_params)
      render json: @game_session
    else
      render json: @game_session.errors, status: :unprocessable_entity
    end
  end

  # DELETE /game_sessions/1
  def destroy
    @game_session.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game_session
      @game_session = GameSession.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def game_session_params
      params.require(:game_session).permit(:start_time, :in_game_minutes)
    end
end
