class Character < ApplicationRecord
  belongs_to :settlement
  has_many :resources, as: :resourceable
  has_many :activities
  
  def can_go_on_activity
    return false if health_status <= 30
    return true if activities.empty?

    activities.none? { |activity| activity.end_time.nil? || activity.is_evaluated.nil? }
  end
end
