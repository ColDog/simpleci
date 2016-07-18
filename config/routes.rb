Rails.application.routes.draw do

  namespace :minions do
    resources :jobs,      only: [:create, :update]
  end

  namespace :api do
    resources :users do
      resources :job_definitions, controller: 'users/job_definitions'
      resources :jobs,            controller: 'users/jobs'
      resources :events,          controller: 'users/events'

      post  'sync'
      get   'teams'
      get   'repos'
    end
  end

  namespace :auth do
    get   ':provider/callback'  => 'sessions#create'
  end

end
