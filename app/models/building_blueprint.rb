class BuildingBlueprint < ApplicationRecord
  serialize :base_resources, JSON
  serialize :necessary_workers, JSON
end
