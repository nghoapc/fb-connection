Rails.application.routes.draw do
  mount Server::API => '/'
  mount GrapeSwaggerRails::Engine => '/documentation'
  # devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'facebooks#index'

  get '/facebook_callback', to: 'facebooks#facebook_callback'

  get '/connect_facebook', to: 'facebooks#connect_facebook'
  # get 'pages', to: 'facebooks#pages'
  resources :facebooks do
  	collection do
      get :pages
      post :subcribe_app
    end
  end
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks' ,
  }

  namespace :webhooks do
    namespace :facebook do
      resources :bot, only: [:index, :create]
    end
  end
end
