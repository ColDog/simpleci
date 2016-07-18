Rails.application.routes.draw do

  namespace :minions do
    resources :jobs,      only: [:create, :update]
  end

  namespace :api do
    resources :users do
      resources :job_definitions, controller: 'users/job_definitions'
      resources :jobs,            controller: 'users/jobs'

      post  'sync'
      get   'teams'
      get   'repos'
    end

    get 'current' => 'users#current'
  end

  namespace :auth do
    get   ':provider/callback'  => 'sessions#create'
  end

end
