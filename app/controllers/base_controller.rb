class BaseController < ApplicationController
    protect_from_forgery with: :null_session  # Off CSRF protection
    before_action :set_resource, only: [:show, :update, :destroy]
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
      
    def index
      render json: resource_class.all
    end
  
    def show
      render json: @resource
    end
  
    def create
      @resource = resource_class.new(resource_params)
      if @resource.save
        render json: @resource, status: :created
      else
        render json: @resource.errors, status: :unprocessable_entity
      end
    end
  
    def update
      if @resource.update(resource_params)
        render json: @resource
      else
        render json: @resource.errors, status: :unprocessable_entity
      end
    end
  
    def destroy
      @resource.destroy
      head :no_content
    end
  
    private
  
    def set_resource
      @resource = resource_class.find(params[:id])
    end
  
    def resource_class
      controller_name.classify.constantize
    end
  
    def resource_params
      raise NotImplementedError, "This #{self.class} cannot respond to resource_params"
    end
  
    def record_not_found
      render json: { error: "Record not found" }, status: :not_found
    end
  end
  