class ActivityLogsController < ApplicationController
  before_action :set_activity_log, only: %i[ show update destroy ]

  # GET /activity_logs
  def index
    @activity_logs = ActivityLog.all

    render json: @activity_logs
  end

  # GET /activity_logs/1
  def show
    render json: @activity_log
  end

  # POST /activity_logs
  def create
    @activity_log = ActivityLog.new(activity_log_params)

    if @activity_log.save
      render json: @activity_log, status: :created, location: @activity_log
    else
      render json: @activity_log.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /activity_logs/1
  def update
    if @activity_log.update(activity_log_params)
      render json: @activity_log
    else
      render json: @activity_log.errors, status: :unprocessable_entity
    end
  end

  # DELETE /activity_logs/1
  def destroy
    @activity_log.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_activity_log
      @activity_log = ActivityLog.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def activity_log_params
      params.require(:activity_log).permit(:description)
    end
end
