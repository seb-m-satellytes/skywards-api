class BuildingsController < ApplicationController
  before_action :check_params, only: [:create]

  def create
    @settlement = Settlement.find(params[:settlement_id])
    @blueprint_id = params[:blueprint_id]
    @worker_id = params[:worker_id]
    @slots_to_use = params[:slots_to_use].split(',')

    current_time = GameSession.first.in_game_minutes
    
    if requirements_met(@settlement, @blueprint_id, @slots_to_use)
      blueprint = BuildingBlueprint.find(@blueprint_id)

      building_params = {
        name: blueprint.name.capitalize,
        building_type: blueprint.name,
        status: "under_construction",
        built_at: GameSession.first.in_game_minutes + blueprint.build_time,
        housing_capacity: blueprint.housing_capacity,
      }

      @building = Building.create!(building_params)
      
      @slots_to_use.each do |slot_to_use_id|
        slot = @settlement.slots.find_by(settlement_slot_id: slot_to_use_id)
        raise "Slot not found or does not belong to settlement" unless slot.settlement_id == @settlement.id
        slot.update!(building: @building)
      end

      @building.deduct_resources_from_settlement

      worker = Character.find(@worker_id)
      worker.activities.create!(
        activity_type: "building",
        activity_target: blueprint.name,
        start_time: current_time,
        end_time: current_time + blueprint.build_time,
      )

      render json: @building, status: :created
    else
      render json: { error: "Requirements not met" }, status: :unprocessable_entity
    end
  end

  private

  def check_params
    unless params[:blueprint_id] && params[:worker_id] && params[:settlement_id]
      render json: { error: "Missing required parameters" }, status: :unprocessable_entity
    end
  end

  def requirements_met(settlement, blueprint_id, slots_to_use)
    # see if settlement has enough slots
    # see if worker is available
    # see if settlement has enough resources
    unless @settlement.available_slots.present?
      return false
    end

    has_enough_slots = @settlement.available_slots > slots_to_use.length
    worker = Character.find(@worker_id)
    worker_available = worker.activities.where("end_time > ?", GameSession.first.in_game_minutes).empty?
    has_resources = @settlement.has_resources?(@blueprint_id)
  end
end
