Rails.application.routes.draw do
  namespace :session do
    resources :user
    post "auth/login", to: "authentication#login"
    get 'confirm-mail', to: "authentication#confirm_mail"
    post 'forget-password', to: "authentication#forget_password"
    post 'change-password', to: "authentication#change_password"
  end

  namespace :profile do
    post "activation/:id", to: "access#change_user_activation"
    post "role/:id", to: "access#change_user_role"
    get "user", to: "user#my_profile"
    get "user/:user_id", to: "user#other_profile"
  end

  namespace :pool do
    resources :candidate
    get "referrals", to: "candidate#referrals_by_self_user"
    get "referrals/:user_id", to: "candidate#referrals_by_query_user"
  end

  namespace :hiring do
    get "interview", to: "interview#index"
    get "interview/:id", to: "interview#show"
    post "interview/:candidate_id", to: "interview#create"
    delete "interview/:interview_id", to: "interview#destroy"
    patch "interview/:id", to: "interview#update"
    post "interview/:interview_id/add-interviewers", to: "interview#add_interviewers"
    get "interview/user/self", to: "interview#for_self_user"
    get "interview/user/:user_id", to: "interview#for_query_user"

    get "feedback", to: "feedback#index"
    get "feedback/:id", to: "feedback#show"
    post "feedback/:interview_id", to: "feedback#create"
    patch "feedback/:id", to: "feedback#update"
    delete "feedback/:feedback_id", to: "feedback#destroy"
    get "feedback/user/self", to: "feedback#given_by_self_user"
    get "feedback/user/:user_id", to: "feedback#given_by_query_user"
  end

  namespace :common do
    resources :question
    resources :lov
    get "question/user/self", to: "question#posted_by_self_user"
    get "question/user/:user_id", to: "question#posted_by_query_user"
  end
end
