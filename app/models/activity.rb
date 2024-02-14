class Activity < ApplicationRecord
  belongs_to :activityable, polymorphic: true
end
