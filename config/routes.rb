Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  namespace :api, defaults: {format: :json} do
    post 'log_in', to: 'authentication#create'
    
    resources :tweets, only: [:create, :update] do
      member do
        get 'stats', to: 'tweets#stats'
        post 'like', to: 'tweets#like'
        delete 'unlike', to: 'tweets#unlike'
        post 'bookmark', to: 'tweets#bookmark'
        delete 'unbookmark', to: 'tweets#unbookmark'
        post 'retweet', to: 'tweets#retweet'
        post 'quote', to: 'tweets#quote'
      end
      resources :replies, only: [:create], to: 'replies#create'
    end

    resources :users, only: [:create] do
      get 'tweets(/page/:page)', to: 'tweets#index'
      get 'tweets_and_replies(/page/:page)', to: 'tweets#tweets_and_replies'
      #get '/register', to: 'users#create'
      #get 'sign_in', to: 'sessions#new'
      #get 'sign_out', to: 'sessions#destroy'
      # for receiving the post request for creating the session
    end
    resources :sessions, only: [:create]
  end
end
