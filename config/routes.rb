Rails.application.routes.draw do
  namespace :session do
    resources :user
    post 'auth/login', to: 'authentication#login'
  end

  namespace :profile do
    post 'activation/:id', to: 'access#change_user_activation'
    post 'role/:id', to: 'access#change_user_role'
  end

  namespace :pool do
    resources :candidate
  end
end
