class BlueprintsController < ApplicationController
  def show
    settlement = Settlement.find(params[:settlement_id])
    blueprints = BuildingBlueprint.all

    enhanced_blueprints = blueprints.select do |blueprint|
      blueprint.unlock_at_settlement_level <= settlement.level
    end.map do |blueprint|
      blueprint_attrs = blueprint.as_json
      blueprint_attrs.merge({ 
        "isBuildable" => settlement.has_resources?(blueprint.id), 
        "baseResources" => blueprint_attrs["base_resources"], 
        "timeToBuild" => blueprint_attrs["build_time"]
      })
    end

    render json: enhanced_blueprints
  end
end
