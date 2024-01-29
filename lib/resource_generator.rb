class ResourceGenerator
  def self.generate_resources
    {
      water: rand(1..5),
      tools: rand(1..5)
    }
  end
end