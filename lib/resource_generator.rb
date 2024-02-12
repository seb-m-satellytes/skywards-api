class ResourceGenerator
  def self.generate_resources(*resources)
    if resources.empty?
      {
        water: rand(1..3),
        food: rand(2..4),
        building_materials: rand(0..3),
        tools: rand(0..2),
      }
    else
      generated_resources = {}
      resources.each do |resource|
        generated_resources[resource.to_sym] = rand(1..4)
      end
      generated_resources
    end
  end
end
