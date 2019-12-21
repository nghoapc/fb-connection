Rails.application.routes.draw do
  # devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'facebooks#index'
  # get 'pages', to: 'facebooks#pages'
  resources :facebooks do
  	collection do
      get :pages
    end
    post :subcribe_app
  end
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks' ,
  }
end
