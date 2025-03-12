# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

statuses = { 0 => :new_task, 1 => :in_progress, 2 => :completed }

(1..5).each do |project_index|
  project = Project.create(
    name: "Project #{project_index}",
    description: "Project #{project_index} description"
  )

  (1..10).each do |task_index|
    project.tasks.create(
      name: "Task #{task_index} | Project #{project_index}",
      description: "Task #{task_index} description | Project #{project_index}",
      status: statuses[task_index%3],
      link: "http://link-project-#{project_index}-task-#{task_index}"
    )
  end
end

User.create(email: 'test_email@example.com', password: 'pwd12345')
