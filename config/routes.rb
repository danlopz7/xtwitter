Rails.application.routes.draw do
  devise_for :users, skip: [ :sessions, :registrations, :passwords ]

  namespace :api do
    # Rutas para sesiones
    post 'users/sign_in', to: 'sessions#create_user_token', as: 'user_session'
    delete 'users/sign_out', to: 'sessions#destroy_user_token', as: 'destroy_user_session'

    # Rutas para registro
    post 'users/sign_up', to: 'registration#create_user', as: 'new_user_registration'

    resources :users, only: [] do
      get 'tweets(/page/:page)', to: 'tweets#index'
      get 'tweets_and_replies(/page/:page)', to: 'tweets#tweets_and_replies'

      resources :tweets, only: [ :show, :create, :update ] do
        member do
          post 'retweet'
          post 'quote'
          post 'like'
          delete 'unlike'
          post 'bookmark'
          get 'stats'
          post 'replies', to: 'tweets#create_reply'
        end
        #post 'replies', to: 'tweets#create_reply'
      end
    end
  end
end