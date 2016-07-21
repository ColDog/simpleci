Rails.application.routes.draw do

  namespace :minions do
    resources :jobs,      only: [:index, :create, :update]
  end

  namespace :api do
    resources :users, only: [:show] do
      resources :job_definitions, controller: 'users/job_definitions'
      resources :jobs,            controller: 'users/jobs'
      resources :events,          controller: 'users/events',           only: [:create, :destroy, :index, :show]
      resources :tokens,          controller: 'users/tokens',           only: [:create, :destroy, :index]
      resources :secrets,         controller: 'users/secrets',          only: [:create, :destroy, :index]

      post  'sync'
      get   'users'
      get   'teams'
      get   'repos'
    end
  end

  namespace :auth do
    get   '/' => 'sessions#index'
    get   ':provider/callback'  => 'sessions#create'
  end

end
