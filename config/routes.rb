Rails.application.routes.draw do
  resources :projects, only: [:index, :show, :create, :update, :destroy] do
    resources :tasks, only: [:index, :show, :create, :update, :destroy]#, shallow: true
  end
end
