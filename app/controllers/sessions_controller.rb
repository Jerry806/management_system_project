class SessionsController < ApplicationController
  protect_from_forgery with: :null_session

  def create
    user = User.new(user_params)
    
    if user.save
      render json: { token: user.authentication_token, email: user.email }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def login
    user = User.find_by(email: user_params[:email])
  
    if user&.valid_password?(user_params[:password])
      render json: { token: user.authentication_token, email: user.email }, status: :ok
    else
      render json: { error: "Invalid email or password" }, status: :unauthorized
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
