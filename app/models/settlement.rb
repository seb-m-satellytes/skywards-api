class Settlement < ApplicationRecord
  has_one :game_session
  has_many :characters
  has_many :slots
  has_many :buildings, -> { distinct }, through: :slots
  has_many :resources, as: :resourceable
  has_many :activities, as: :activityable, dependent: :destroy
  has_one :xp_point, as: :xpable, dependent: :destroy

  include GameEventLoggable
  
  # after_create :initialize_slots

  def increase_xp(amount)
    xp_point = self.xp_point || self.create_xp_point
    xp_point.xp += amount
    xp_point.save!

    log_event("Settlement got #{amount} XP!")

    level_up
  end

  def level_up
    levels= {
      1 => 0,
      2 => 1500,
      3 => 3000,
    }

    current_xp = self.xp_point.xp
    next_level = self.level + 1
    next_level_xp = levels[next_level]

    if current_xp >= next_level_xp
      self.level = next_level
      self.save!
      log_event("Settlement leveled up to level #{next_level}!")
    end
  end

  def max_building_slots
    slots.count
  end

  def available_slots
    slots.where(building_id: nil).where(usable: 1).count
  end

  def clearable_slots
    slots.where(building_id: nil).where(usable: 0).count
  end

  def total_housing_capacity
    total_housing_capacity = 0
    buildings.joins(:slots).distinct.each do |building|
      next if building.status != 'usable'
      total_housing_capacity += building.housing_capacity || 0
    end
    total_housing_capacity
  end

  def update_resource(resource_type, amount)
    resource = self.resources.find_or_initialize_by(resource_type: resource_type)
    
    if resource.new_record?
      resource.amount = amount
    else
      resource.amount += amount
    end
    
    resource.save!
    log_event("#{resource_type.capitalize} descreased by #{amount.abs}.") if amount < 0
    log_event("#{resource_type.capitalize} increased by #{amount.abs}.") if amount > 0
  end

  def has_resources?(blueprint_id)
    blueprint = BuildingBlueprint.find(blueprint_id)
    # base resoucers is an object: {"building_materials":5,"tools":2}
    blueprint.base_resources.each do |resource, amount|
      resource = self.resources.find_by(resource_type: resource)
      return false if resource.nil? || resource.amount < amount
    end

    true
  end

  def all_eat(mealname)
    log_event("Preparing to eat #{mealname}.")

    max_food_per_character_day = 3
    max_water_per_character_day = 3
    max_day_buffer = 6

    citizens_in_settlement = self.characters.count
    max_consumption_per_day = citizens_in_settlement * (max_food_per_character_day + max_water_per_character_day)
    max_consumption_buffer = max_day_buffer * max_consumption_per_day

    current_water = self.resources.find_by(resource_type: 'water').amount || 0
    current_food = self.resources.find_by(resource_type: 'food').amount || 0

    # If there is no food or water, characters will not eat
    return if current_food == 0 || current_water == 0
      
    current_buffer_days = (current_food + current_water) / max_consumption_per_day

    log_event("Current buffer days for food: #{current_buffer_days}")

    self.characters.each do |character|
      food_consumed, water_consumed = character.consume_meal(current_buffer_days, mealname)
      self.update_resource('food', -food_consumed)
      self.update_resource('water', -water_consumed)
    end
  end

  private
  def initialize_slots
    5.times { slots.create }
  end
end
