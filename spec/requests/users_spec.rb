require 'rails_helper'

RSpec.describe "Users API", type: :request do
  describe "POST /register" do
    let(:valid_params) { { user: { email: "test@example.com", password: "password123" } } }

    it "registers a new user" do
      post "/register", params: valid_params
      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)["email"]).to eq("test@example.com")
    end
  end

  describe "POST /login" do
    let(:user) { create(:user, password: "password123") }
    let(:valid_params) { { user: { email: user.email, password: "password123" } } }

    it "logs in a user and returns a token" do
      post "/login", params: valid_params
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["token"]).to be_present
    end
  end
end
