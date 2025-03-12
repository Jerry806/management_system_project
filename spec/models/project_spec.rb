require 'rails_helper'

RSpec.describe Project, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name).with_message('Name is required') }
    it { should validate_presence_of(:description).with_message('Description is required') }
  end

  describe 'associations' do
    it { should have_many(:tasks).dependent(:destroy) }
  end
end
