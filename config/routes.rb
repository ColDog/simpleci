Rails.application.routes.draw do

  resources :jobs,      only: [:create, :update]
  resources :repos do
    resources :jobs,    only: [:create, :update] do
      get '/output' => 'repos/jobs#output'
    end
  end

  resources :accounts do
    resources :configs
    resources :repos
  end

  # routes from the current user
  post  '/user/sync'                => 'users#sync'
  get   '/user/teams'               => 'users#teams'
  get   '/user'                     => 'users#current'

  get   '/auth/:provider/callback'  => 'sessions#create'
end
