class Settlement < ApplicationRecord
  has_many :characters
  has_many :resources, as: :resourceable

  def update_resource(resource_type, amount)
    resource = self.resources.find_or_initialize_by(resource_type: resource_type)
    
    if resource.new_record?
      resource.amount = amount
    else
      resource.amount += amount
    end
    
    resource.save!
  end

  def all_eat(mealname)
    logger.info('Calculating food')

    max_food_per_character_day = 3
    max_water_per_character_day = 3
    max_day_buffer = 6

    citizens_in_settlement = self.characters.count
    max_consumption_per_day = citizens_in_settlement * (max_food_per_character_day + max_water_per_character_day)
    max_consumption_buffer = max_day_buffer * max_consumption_per_day

    current_water = self.resources.find_by(resource_type: 'water').amount || 0
    current_food = self.resources.find_by(resource_type: 'food').amount || 0
    current_buffer_days = (current_food + current_water) / max_consumption_per_day

    logger.info("Current buffer days: #{current_buffer_days}")

    self.characters.each do |character|
      food_consumed, water_consumed = character.consume_meal(current_buffer_days, mealname)
      self.update_resource('food', -food_consumed)
      self.update_resource('water', -water_consumed)
    end
  end
end
