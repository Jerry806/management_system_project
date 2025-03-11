class TasksController < BaseController
    def index
      tasks = Task.where({ project_id: params[:project_id] })
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
  
    def resource_params
      params.require(:task).permit(:name, :description, :status, :link).merge(project_id: params[:project_id])
    end
  
  end
  