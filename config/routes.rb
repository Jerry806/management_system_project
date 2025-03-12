Rails.application.routes.draw do
  devise_for :users, skip: :all
  resources :projects, only: [:index, :show, :create, :update, :destroy] do
    resources :tasks, only: [:index, :show, :create, :update, :destroy]#, shallow: true
  end
  post 'register', to: 'sessions#create'
  post 'login', to: 'sessions#login'
end
