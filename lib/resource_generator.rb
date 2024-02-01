class ResourceGenerator
  def self.generate_resources
    {
      water: rand(1..3),
      food: rand(2..4),
      tools: rand(0..3)
    }
  end
end
