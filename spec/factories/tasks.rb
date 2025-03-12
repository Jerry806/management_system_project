FactoryBot.define do
  factory :task do
    name { "Test Task Name" }
    description { "Test Task Description" }
    link { "http://example.com/task_link" }
  end
end
