class Task < ApplicationRecord
  belongs_to :project

  enum status: { new_task: 0, in_progress: 1, completed: 2 }
end
