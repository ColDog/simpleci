Rails.application.routes.draw do

  namespace :minions do
    resources :jobs,      only: [:create, :update]
  end

  namespace :api do
    resources :users do
      resources :job_definitions, controller: 'users/job_definitions'
      resources :jobs,            controller: 'users/jobs'

      get 'account/sync'   => 'users/accounts#sync'
      get 'account/teams'  => 'users/accounts#teams'
      get 'account/repos'  => 'users/accounts#repos'
      get 'account/repos'  => 'users/accounts#repos'
    end

    get 'current' => 'users#current'
  end

  namespace :auth do
    get   ':provider/callback'  => 'sessions#create'
  end

end
