class Building < ApplicationRecord
  has_many :slots, dependent: :nullify
  has_one :settlement, through: :slot
  has_many :activities, as: :activityable, dependent: :destroy
  # before_create :deduct_resources_from_settlement
  
  def is_finished(built_at, in_game_minutes)
    in_game_minutes - built_at > 0
  end

  def deduct_resources_from_settlement
    blueprint = BuildingBlueprint.find_by(name: self.building_type)
    blueprint.base_resources.each do |resource_type, amount|
      settlement = Settlement.find(self.slots.first.settlement_id)
      
      resource = settlement.resources.find_by(resource_type: resource_type)
      
      if resource
        resource.amount -= amount
        
        unless resource.save
          errors.add(:base, "Insufficient #{resource_type} resources in settlement.")
          throw :abort # Prevent the building from being saved
        end
      else
        errors.add(:base, "Resource #{resource_type} not found for settlement.")
        throw :abort
      end  
    end
  end
end
