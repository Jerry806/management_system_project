class ProjectsController < BaseController
  def index
    super && return unless params.key?(:task_status) || params.key?(:with_tasks)
    
    @render_params = {include: :tasks}
    @projects = Project.includes(:tasks)
    select_tasks_by_status if is_status_condition?

    render json: @projects.as_json(@render_params)
  end
  
  def show
    if params.key?(:with_tasks)
      render json: Project.find(params[:id]).as_json(include: :tasks)
    else
      super
    end
  end

  private

  def is_status_condition?
    params.key?(:task_status) && Task.validate_status(params[:task_status])
  end

  def select_tasks_by_status
    @projects = @projects.map do |project|
      project.as_json.merge(tasks: project.tasks.select { |task| task.status == params[:task_status] })
    end
    @render_params = {}
  end

  def resource_params
    params.require(:project).permit(:name, :description) 
  end
end
  