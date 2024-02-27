class ActivitiesController < ApplicationController
  before_action :set_activity, only: %i[ show update destroy ]

  # GET /activities
  def index
    @activities = Activity.all

    render json: @activities
  end

  # GET /activities/1
  def show
    render json: @activity
  end

  # POST /activities
  def create
    @activity = Activity.new(activity_params)

    if @activity.save
      render json: @activity, status: :created, location: @activity
    else
      render json: @activity.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /activities/1
  def update
    if @activity.update(activity_params)
      render json: @activity
    else
      render json: @activity.errors, status: :unprocessable_entity
    end
  end

  # DELETE /activities/1
  def destroy
    @activity.destroy!
  end

  def evaluate
    @activity = Activity.find(params[:id])
    
    is_ended = @activity.end_time < GameSession.first.in_game_minutes
    is_evaluated = @activity.is_evaluated

    if not is_ended
      render json: { error: 'Activity is not ended yet' }, status: :unprocessable_entity
      return
    end

    if is_evaluated
      render json: { error: 'Activity is already evaluated' }, status: :unprocessable_entity
      return
    end

    if @activity.activity_type == 'gathering'
      if is_ended && !is_evaluated
        resources_gained = ResourceGenerator.generate_resources

        settlement = @activity.activityable.settlement if @activity.activityable_type == 'Character'

        resources_gained.each do |type, amount|
          settlement.update_resource(type, amount) if settlement.present?
        end

        @activity.is_evaluated = Time.now
        @activity.save!
        render json: { finished: 'gathering', resources_gained: resources_gained }
      end
    end

    if @activity.activity_type == 'building'
      if is_ended && !is_evaluated
        @activity.is_evaluated = Time.now
        @activity.save!
      end

      render json: { finished_building: @activity.activity_target}
    end

    if @activity.activity_type == 'clearing_slot'
      if is_ended && !is_evaluated
        character = @activity.activityable if @activity.activityable_type == 'Character'

        settlement = character.settlement
        slot = settlement.slots.find_by(settlement_slot_id: @activity.activity_target)
        slot.update!(usable: 1)

        resources_gained = ResourceGenerator.generate_resources(:building_materials, :tools)

        resources_gained.each do |type, amount|
          settlement.update_resource(type, amount)
        end

        @activity.is_evaluated = Time.now
        @activity.save!
        render json: { finished: 'clearing_slot', resources_gained: resources_gained }
      end
    end

    if @activity.activity_type == 'hire'
      if is_ended && !is_evaluated
        settlement = @activity.activityable if @activity.activityable_type == 'Settlement'

        character = Character.new(
          name: "#{Faker::Name.first_name} #{Faker::Name.last_name}",
          age: rand(18..70),
          settlement_id: settlement.id,
          specialization: @activity.activity_target,
          morale_status: rand(80..100),
          health_status: rand(55..90),
          skill_level: rand(1..settlement.level)
        )

        if character.save
          @activity.is_evaluated = Time.now
          @activity.save!
          render json: { finished: 'hiring', new_character: character }
        else
          render json: { error: character.errors }, status: :unprocessable_entity
        end

      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
  def set_activity
    @activity = Activity.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def activity_params
    params.require(:activity).permit(:activity_type, :start_time, :end_time, :character_id, :settlement_id)
  end
end
