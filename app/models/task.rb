class Task < ApplicationRecord
  belongs_to :project

  enum status: { new_task: 0, in_progress: 1, completed: 2 }
  validates :name, presence: { message: "Name is required" }
  validates :description, presence: { message: "Description is required" }
  validates :link, presence: { message: "Link is required" }
  validates :status, inclusion: { in: statuses.keys.map(&:to_s), message: "%{value} is not a valid status" }

  def self.validate_status(status_for_validate)
    statuses.keys.map(&:to_s).include?(status_for_validate)
  end
end
