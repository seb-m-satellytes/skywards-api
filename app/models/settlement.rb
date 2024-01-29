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
end
