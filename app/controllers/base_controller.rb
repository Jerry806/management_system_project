class BaseController < ApplicationController
    protect_from_forgery with: :null_session  # Off CSRF protection
    acts_as_token_authentication_handler_for User
    before_action :set_resource, only: [:show, :update, :destroy]
    after_action :clear_cache, only: [:create, :update, :destroy]
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
      
    def index
      resources = cache_collection { resource_class.all }
      render json: resources
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

    def cache_collection
      Rails.cache.fetch(cache_key, expires_in: 10.minutes) { yield }
    end
  
    def cache_key
      key = "#{controller_name}_collection"
      key += "_id_#{params[:id]}" if params[:id].present?
      key += "_status_#{params[:status]}" if params[:status].present?
      key += "_task_status_#{params[:task_status]}" if params[:task_status].present?
      key += "_with_tasks_#{params[:with_tasks]}" if params.key?(:with_tasks)
      key
    end

    def clear_cache
      Rails.cache.delete_matched("#{controller_name}_collection")
    end

    def set_resource
      @resource = cache_collection { resource_class.find(params[:id]) }
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

    def authenticate_user!
      unless user_signed_in?
        render json: { error: 'Unauthorized' }, status: :unauthorized
      end
    end
  end
  