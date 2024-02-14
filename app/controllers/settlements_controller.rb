class SettlementsController < ApplicationController
  before_action :set_settlement, only: %i[ show update destroy ]

  # GET /settlements
  def index
    @settlements = Settlement.all

    render json: @settlements
  end

  # GET /settlements/1
  def show
    includes_array = []
    includes_array << :characters if params[:includeCharacters] == 'true'
    includes_array << :resources if params[:includeResources] == 'true'
    includes_array << :buildings if params[:includeBuildings] == 'true'

    @settlement = Settlement.includes(includes_array).find(params[:id])

    render json: @settlement.as_json(
      include: includes_array,
      methods: [:available_slots, :max_building_slots]
    )
  end

  # POST /settlements
  def create
    @settlement = Settlement.new(settlement_params)

    if @settlement.save
      render json: @settlement, status: :created, location: @settlement
    else
      render json: @settlement.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /settlements/1
  def update
    if @settlement.update(settlement_params)
      render json: @settlement
    else
      render json: @settlement.errors, status: :unprocessable_entity
    end
  end

  # DELETE /settlements/1
  def destroy
    @settlement.destroy!
  end

  def clear_slots
    current_time = GameSession.first.in_game_minutes
    @settlement = Settlement.find(params[:id])
    @worker_id = params[:worker_id]
    slot_to_clear = params[:slot]

    slot = @settlement.slots.find_by(settlement_slot_id: slot_to_clear)

    if slot.usable == 1
      render json: { error: "Slot is already clear" }, status: :unprocessable_entity
      return
    end

    if slot.building.present?
      render json: { error: "Slot is occupied" }, status: :unprocessable_entity
      return
    end


    activities = ::CONSTS["activities"]
    activity_type = "clearing_slot"

    duration = activities[activity_type]['duration']

    worker = Character.find(@worker_id)
    worker.activities.create!(
      activity_type: activity_type,
      activity_target: slot_to_clear,
      start_time: current_time,
      end_time: current_time + duration * 60
    )

    render json: { message: "#{activity_type} started!" }, status: :ok
  end

  def hire
    @settlement = Settlement.find(params[:id])

    activity = @settlement.activities.create!(
      activity_type: "hire",
      activity_target: params[:specialization],
      start_time: GameSession.first.in_game_minutes,
    )

    if activity.persisted?
      render json: { message: "Hire started for #{params[:specialization]}!" }, status: :ok
    else
      render json: { error: "Could not start hire activity" }, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_settlement
      @settlement = Settlement.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def settlement_params
      params.require(:settlement).permit(:name, :location, :level)
    end
end
