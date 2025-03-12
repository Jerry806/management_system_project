require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should validate_presence_of(:password) }
  end

  describe "authentication token" do
    let(:user) { create(:user) }

    it "generates an authentication token on create" do
      expect(user.authentication_token).to be_present
    end

    it "generates a new token when reset_token! is called" do
      old_token = user.authentication_token
      user.reset_token!
      expect(user.authentication_token).not_to eq(old_token)
    end
  end
end
