Rails.application.routes.draw do

  resources :jobs,      only: [:create, :update]

  resources :repos do
    resources :jobs, controller: 'repos/jobs', only: [:create, :update, :index, :show] do
      get '/output' => 'repos/jobs#output'
    end
  end

  resources :accounts do
    resources :configs,     controller: 'accounts/configs'
    resources :repos,       controller: 'accounts/repos'
  end

  # routes from the current user
  post  '/user/sync'                => 'users#sync'
  get   '/user/teams'               => 'users#teams'
  get   '/user'                     => 'users#current'

  get   '/auth/:provider/callback'  => 'sessions#create'

  post  '/hooks/github'             => 'hooks#github'
  post  '/hooks/bitbucket'          => 'hooks#bitbucket'
end
