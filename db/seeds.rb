# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# Clear existing data
Resource.delete_all
Activity.delete_all

StatusEffect.delete_all
Slot.delete_all

Character.delete_all

Building.delete_all
Settlement.delete_all

GameSession.delete_all

BuildingBlueprint.delete_all


# GameSessions
game_session = GameSession.create(in_game_minutes: 0, start_time: Time.now)
# BuildingBlueprints
BuildingBlueprint.create([
  { name: 'Tent', category: 'residents', base_resources: {building_materials: 5, tools: 2}, necessary_workers: {generic: 1}, build_time: 240, slots_required: 1, unlock_at_settlement_level: 1, housing_capacity: 3 },
  { name: 'Rainwater Purifier', category: 'economy', base_resources: {building_materials: 10, tools: 10}, necessary_workers: {engineer: 2}, build_time: 360, slots_required: 2, unlock_at_settlement_level: 2, housing_capacity: nil },
  { name: 'Large Tent', category: 'residents', base_resources: {building_materials: 10, tools: 25}, necessary_workers: {engineer: 2, generic: 2}, build_time: 480, slots_required: 2, unlock_at_settlement_level: 3, housing_capacity: 5 }
])

# Settlements
settlement1 = Settlement.create(name: 'Outside', location: 'outside', level: 0, game_session_id: game_session)
settlement2 = Settlement.create(name: Faker::Address.community, location: Faker::Address.street_address, level: 1, game_session_id: game_session)

# Characters
Character.create([
  { name: Faker::Name.name, age: rand(18..70), health_status: rand(50..85), skill_level: 1, settlement: settlement2, morale_status: rand(35..65), specialization: 'gatherer' },
  { name: Faker::Name.name, age: rand(18..70), health_status: rand(50..85), skill_level: 1, settlement: settlement2, morale_status: rand(35..65), specialization: 'engineer' },
])

injuredChar = Character.create(name: "#{Faker::Name.first_name Faker::Name.last_name}", age: rand(18..70), health_status: rand(50..85), skill_level: 1, settlement: settlement2, morale_status: rand(35..65), specialization: 'engineer')


building_tent = Building.create(name: 'Tent', building_type: 'tent', built_at: 0, slot: 0, status: 'usable', housing_capacity: 3)
# Resources
Resource.create([
  { resource_type: 'water', amount: 25, resourceable: settlement2 },
  { resource_type: 'food', amount: 25, resourceable: settlement2 },
  { resource_type: 'tools', amount: 0, resourceable: settlement2 },
  { resource_type: 'building_materials', amount: 1, resourceable: settlement2 }
])

# Slots
Slot.create([
  { settlement: settlement2, building: building_tent, settlement_slot_id: 1, usable: true },
  { settlement: settlement2, building: nil, settlement_slot_id: 2, usable: false },
  { settlement: settlement2, building: nil, settlement_slot_id: 3, usable: false },
  { settlement: settlement2, building: nil, settlement_slot_id: 4, usable: false },
  { settlement: settlement2, building: nil, settlement_slot_id: 5, usable: false }
])

# StatusEffects
StatusEffect.create([
  { name: 'injured', start_time: 0, end_time: nil, character: injuredChar }
])

# Buildings

