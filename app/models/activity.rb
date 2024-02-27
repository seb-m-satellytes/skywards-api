class Activity < ApplicationRecord
  belongs_to :activityable, polymorphic: true
  after_create :log_create_activity
  after_update :log_update_activity

  include GameEventLoggable

  private
  def log_create_activity
    log_event("Activity started: #{self.activity_type}.", self.activityable)
  end

  def log_update_activity
    log_event("Activity updated: #{self.activity_type}.", self.activityable)
  end
end
