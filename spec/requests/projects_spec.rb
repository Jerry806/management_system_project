require 'rails_helper'

RSpec.describe 'Projects API', type: :request do
  let!(:user) { create(:user) }
  let!(:projects) do
    create_list(:project, 3).each do |project|
      Task.statuses.keys.each do |status|
        create_list(:task, 2, project: project, status: status)
      end
    end
  end
  let!(:project_id) { projects.first.id }
  let!(:headers) { { 'X-User-Email': "#{user.email}", 'X-User-Token': "#{user.authentication_token}" } }
  let(:valid_attributes) { { project: { name: 'New Project', description: 'A test project' } } }
  let(:valid_params) { { project: { name: "Updated Name" } } }

  context "when authenticated" do
    # GET /projects
    describe 'GET /projects' do
      it 'returns the projects' do
        get '/projects', headers: headers
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body).size).to eq(3)
      end
      it "returns the projects with all tasks" do
        get "/projects?with_tasks", headers: headers
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body).first["tasks"].size).to eq(6)
      end
      it "returns the projects with only tasks of the given status" do
        status_val = "in_progress"
        get "/projects?task_status=#{status_val}", headers: headers
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response.first["tasks"].count).to eq(2)
        expect(json_response.first["tasks"].all? { |t| t["status"] == status_val }).to be true
      end
    end

    # GET /projects/:id
    describe 'GET /projects/:id' do    
      it 'returns the project' do
        get "/projects/#{project_id}", headers: headers
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['id']).to eq(project_id)
      end
      it "returns the project with all tasks" do
        get "/projects/#{project_id}?with_tasks", headers: headers
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)["tasks"].size).to eq(6)
      end
      it "returns the project with only tasks of the given status" do
        status_val = "completed"
        get "/projects/#{project_id}?task_status=#{status_val}", headers: headers
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response["tasks"].size).to eq(2)
        expect(json_response["tasks"].all? { |t| t["status"] == status_val }).to be true
      end
    end

    # POST /projects
    describe 'POST /projects' do
      it 'creates a new project' do
        expect { post '/projects', params: valid_attributes, headers: headers }.to change(Project, :count).by(1)
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['name']).to eq("New Project")
      end
    end

    # PUT /projects/:id
    describe "PUT /projects/:id" do
      it "updates the project" do
        put "/projects/#{project_id}", params: valid_params, headers: headers
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)["name"]).to eq("Updated Name")
      end
    end

    # DELETE /projects/:id
    describe "DELETE /projects/:id" do
      it "deletes the project" do
        delete "/projects/#{project_id}", headers: headers
        expect(response).to have_http_status(:no_content)
        expect(Project.exists?(project_id)).to be_falsey
      end
    end
  end

  context "when unauthorized" do
    # GET /projects
    it "returns 401 when getting projects" do
      get "/projects"
      expect(response).to have_http_status(:unauthorized)
    end

    # GET /projects/:id
    it 'returns 401 when getting project' do
      get "/projects/#{project_id}"
      expect(response).to have_http_status(:unauthorized)
    end

    # POST /projects
    it 'returns 401 when creating project' do
      post '/projects', params: valid_attributes
      expect(response).to have_http_status(:unauthorized)
    end

    # PUT /projects/:id
    it 'returns 401 when updateing project' do
      put "/projects/#{project_id}", params: valid_params
      expect(response).to have_http_status(:unauthorized)
    end
  
    # DELETE /projects/:id
    it 'returns 401 when deleting project' do
      delete "/projects/#{project_id}"
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
