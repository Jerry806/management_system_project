require 'rails_helper'

RSpec.describe "Tasks API", type: :request do
  let!(:user) { create(:user) }
  let!(:project) do
    create(:project) do |project|
      Task.statuses.keys.each do |status|
        create_list(:task, 2, project: project, status: status)
      end
    end
  end
  let!(:task_id) { project.tasks.first.id }
  let!(:headers) { { 'X-User-Email': "#{user.email}", 'X-User-Token': "#{user.authentication_token}" } }
  let(:valid_attributes) { { task: { name: "New Task", description: "Task description", link: "http://example.com" } } }
  let(:valid_params) { { task: { name: "Updated Task" } } }

  context "when authenticated" do
    # GET /projects/:project_id/tasks
    describe "GET /projects/:project_id/tasks" do
      it "returns all tasks for a project" do
        get "/projects/#{project.id}/tasks", headers: headers
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body).size).to eq(6)
      end
      it "returns tasks of the given status" do
        status_val = "in_progress"
        get "/projects/#{project.id}/tasks?status=#{status_val}", headers: headers
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response.count).to eq(2)
        expect(json_response.all? { |t| t["status"] == status_val }).to be true
      end
    end

    # GET /projects/:project_id/tasks/:id
    describe "GET /projects/:project_id/tasks/:id" do
      it "returns the task" do
        get "/projects/#{project.id}/tasks/#{task_id}", headers: headers
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)["id"]).to eq(task_id)
      end
    end


    # POST /projects/:project_id/tasks
    describe "POST /projects/:project_id/tasks" do
      it "creates a new task" do
        post "/projects/#{project.id}/tasks", params: valid_attributes, headers: headers
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)["name"]).to eq("New Task")
      end
    end

    # PUT /projects/:project_id/tasks/:id
    describe "PUT /projects/:project_id/tasks/:id" do
      it "updates the task" do
        put "/projects/#{project.id}/tasks/#{task_id}", params: valid_params, headers: headers
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)["name"]).to eq("Updated Task")
      end
    end

    # DELETE /projects/:project_id/tasks/:id
    describe "DELETE /projects/:project_id/tasks/:id" do
      it "deletes the task" do
        delete "/projects/#{project.id}/tasks/#{task_id}", headers: headers
        expect(response).to have_http_status(:no_content)
        expect(Task.exists?(task_id)).to be_falsey
      end
    end
  end

  context "when unauthorized" do
    # GET /projects/:project_id/tasks
    it "returns 401 when getting tasks" do
      get "/projects/#{project.id}/tasks"
      expect(response).to have_http_status(:unauthorized)
    end

    # GET /projects/:project_id/tasks/:id
    it "returns 401 when getting task" do
      get "/projects/#{project.id}/tasks/#{task_id}"
      expect(response).to have_http_status(:unauthorized)
    end

    # POST /projects/:project_id/tasks
    it "returns 401 when creating task" do
      post "/projects/#{project.id}/tasks", params: valid_attributes
      expect(response).to have_http_status(:unauthorized)
    end

    # PUT /projects/:project_id/tasks/:id
    it "returns 401 when updating task" do
      put "/projects/#{project.id}/tasks/#{task_id}", params: valid_params
      expect(response).to have_http_status(:unauthorized)
    end

    # PUT /projects/:project_id/tasks/:id
    it "returns 401 when deleting task" do
      delete "/projects/#{project.id}/tasks/#{task_id}"
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
