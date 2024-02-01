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

    if is_ended && !is_evaluated
      resources_gained = ResourceGenerator.generate_resources

      resources_gained.each do |type, amount|
        @activity.character.settlement.update_resource(type, amount)
      end

      @activity.is_evaluated = Time.now
      @activity.save!
    end

    render json: { resources_gained: resources_gained }
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
