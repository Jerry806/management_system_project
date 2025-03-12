class ProjectsController < BaseController
  def index
    super && return unless is_any_params?
    
    @render_params = {include: :tasks}
    @projects = Project.includes(:tasks)
    select_tasks_by_status if is_status_condition?

    render json: @projects.as_json(@render_params)
  end
  
  def show
    super && return unless is_any_params?

    if params.key?(:task_status) 
      project = Project.includes(:tasks).where(id: params[:id])
                     .where(tasks: { status: params[:task_status] }).first
      render json: project.as_json(include: :tasks)
    else
      render json: Project.find(params[:id]).as_json(include: :tasks)
    end
  end

  private

  def is_any_params?
    params.key?(:task_status) || params.key?(:with_tasks)
  end

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
  