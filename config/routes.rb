Rails.application.routes.draw do
  namespace :session do
    resources :user
    post 'auth/login', to: 'authentication#login'
  end

  namespace :profile do
    post 'activation/:id', to: 'access#change_user_activation'
    post 'role/:id', to: 'access#change_user_role'
    get 'user', to: 'user#my_profile'
    get 'user/:user_id', to: 'user#other_profile'
  end

  namespace :pool do
    resources :candidate
    get 'referrals', to: 'candidate#referrals_by_self_user'
    get 'referrals/:user_id', to: 'candidate#referrals_by_query_user'
  end

  namespace :hiring do
    get 'interview', to: 'interview#index'
    get 'interview/:id', to: 'interview#show'
    post 'interview/:candidate_id', to: 'interview#create'
    delete 'interview/:interview_id', to: 'interview#destroy'
    patch 'interview/:id', to: 'interview#update'
    post 'interview/:interview_id/add-interviewers', to: 'interview#add_interviewers'
    get 'interview/user', to: 'interview#for_self_user'
    get 'interview/user/:user_id', to: 'interview#for_query_user'

    get 'feedback', to: 'feedback#index'
    get 'feedback/:id', to: 'feedback#show'
    post 'feedback/:interview_id', to: 'feedback#create'
    patch 'feedback/:id', to: 'feedback#update'
    delete 'feedback/:feedback_id', to: 'feedback#destroy'
    get 'feedback/user', to: 'feedback#given_by_self_user'
    get 'feedback/user/:user_id', to: 'feedback#given_by_query_user'
  end
end
