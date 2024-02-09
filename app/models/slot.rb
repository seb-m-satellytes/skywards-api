class Slot < ApplicationRecord
  belongs_to :settlement
  belongs_to :building, optional: true
end
