Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registration' }

  namespace :api do

    # Rutas para sesiones
    post 'users/sign_in', to: 'sessions#create_user_token', as: 'user_session'
    delete 'users/sign_out', to: 'sessions#destroy_user_token', as: 'destroy_user_session'

    # Rutas para registro
    get 'users/sign_up', to: 'registration#create_user', as: 'new_user_registration'
    
    resources :tweets, only: [:create, :update, :show] do
      member do
        get 'stats', to: 'tweets#stats'
        post 'like', to: 'tweets#like'
        delete 'unlike', to: 'tweets#unlike'
        post 'bookmark', to: 'tweets#bookmark'
        post 'retweet', to: 'tweets#retweet'
        post 'quote', to: 'tweets#quote'
      end
      resources :replies, only: [:create], to: 'tweets#create_reply'
    end

    resources :users, only: [] do
      resources :tweets, only: [:index] do
        get 'tweets(/page/:page)', on: :collection, to: 'tweets#index'
        #get 'tweets(/page/:page)', to: 'tweets#index'
        #get 'tweets_and_replies(/page/:page)', to: 'tweets#tweets_and_replies'
      end
      get 'tweets_and_replies(/page/:page)', on: :member, to: 'tweets#tweets_and_replies'
    end
  end
end
