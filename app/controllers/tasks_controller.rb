  class TasksController < BaseController
    def index
      tasks = Task.where(find_params)
      render json: tasks
    end
  
    def update
      if params[:task] && params[:task][:status] && !Task.validate_status(params[:task][:status])
        render json: { error: "#{params[:task][:status]} is not a valid status" }, status: :unprocessable_entity
      else
        super
      end
    end
  
    private
  
    def find_params
      { project_id: params[:project_id] }.merge(
        params[:status].present? && Task.validate_status(params[:status]) ? { status: params[:status] } : {}
      )
    end
  
    def resource_params
      params.require(:task).permit(:name, :description, :status, :link).merge(project_id: params[:project_id])
    end
  end
  