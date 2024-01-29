class Character < ApplicationRecord
  belongs_to :settlement
  has_many :resources, as: :resourceable
  has_many :activities
end
