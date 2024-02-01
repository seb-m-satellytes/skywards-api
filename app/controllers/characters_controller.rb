class CharactersController < ApplicationController
  before_action :set_character, only: %i[ show update destroy ]

  # GET /characters
  def index
    @characters = Character.all

    render json: @characters
  end

  # GET /characters/1
  def show
    includes_array = []
    includes_array << :resources if params[:includeResources] == 'true'
    includes_array << :activities if params[:includeActivities] == 'true'

    @character = Character.includes(includes_array).find(params[:id])

    render json: @character, include: includes_array
  end

  # POST /characters
  def create
    @character = Character.new(character_params)

    if @character.save
      render json: @character, status: :created, location: @character
    else
      render json: @character.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /characters/1
  def update
    if @character.update(character_params)
      render json: @character
    else
      render json: @character.errors, status: :unprocessable_entity
    end
  end

  # DELETE /characters/1
  def destroy
    @character.destroy!
  end

  def start_activity
    current_time = GameSession.first.in_game_minutes
    character = Character.find(params[:id])
    activity_type = params[:activity_type]
    object_type = params[:object_type]

    if character.activities.where("end_time > ?", current_time).exists?
      return render json: { error: "Character is already engaged in an activity." }, status: :unprocessable_entity
    end

    duration = if object_type
                 ::CONSTS[activity_type][object_type][:duration]
               else
                 ::CONSTS[activity_type][:duration]
               end

    activity = character.activities.create(
      activity_type: activity_type,
      start_time: current_time,
      end_time: current_time + duration * 60
    )
    
    if activity.persisted?
      render json: { message: "Gathering started!", activity_id: activity.id }, status: :ok
    else
      render json: { errors: activity.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_character
      @character = Character.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def character_params
      params.require(:character).permit(:name, :age, :health_status, :skill_level, :current_activity)
    end
end
