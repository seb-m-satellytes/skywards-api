class Settlement < ApplicationRecord
  has_many :characters
  has_many :resources, as: :resourceable
end
