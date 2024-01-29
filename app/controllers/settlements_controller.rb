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

    @settlement = Settlement.includes(includes_array).find(params[:id])

    render json: @settlement, include: includes_array
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
