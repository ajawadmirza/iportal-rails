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

  namespace :hiring do
    get 'interview', to: 'interview#index'
    post 'interview/:candidate_id', to: 'interview#create'
    delete 'interview/:interview_id', to: 'interview#destroy'
    post 'interview/:interview_id/add-interviewers', to: 'interview#add_interviewers'

    get 'feedback', to: 'feedback#index'
    post 'feedback/:interview_id', to: 'feedback#create'
    delete 'feedback/:feedback_id', to: 'feedback#destroy'
    get 'feedback/user', to: 'feedback#given_by_user'
  end
end
