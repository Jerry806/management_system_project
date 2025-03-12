require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name).with_message("Name is required") }
    it { should validate_presence_of(:description).with_message("Description is required") }
    it { should validate_presence_of(:link).with_message("Link is required") }
    it { should define_enum_for(:status).with_values(new_task: 0, in_progress: 1, completed: 2) }
  end

  describe 'associations' do
    it { should belong_to(:project) }
  end

  describe 'enum' do
    it { should define_enum_for(:status).with_values(new_task: 0, in_progress: 1, completed: 2) }
  end
end
