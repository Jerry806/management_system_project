class ProjectsController < BaseController
    private
  
    def resource_params
      params.require(:project).permit(:name, :description) 
    end
  end
  