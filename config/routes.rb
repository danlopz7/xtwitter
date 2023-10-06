Rails.application.routes.draw do
  resources :tweets
  devise_for :users #, skip: [ :sessions, :registrations, :passwords ]

  root to: 'home#index' # Esta es tu ruta raíz que manejará los comportamientos basados en la autenticación.

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

  namespace :web do
    # Ruta del perfil del usuario actual
    get 'profile', to: 'users#profile', as: 'current_user_profile'
  
    # Rutas relacionadas con usuarios específicos
    # GET /user/:username Should display the personal information of the user: 
    resources :user, only: ["show"], param: :username, controller: "users" do
      #get 'user/:username', to: 'users#show'
      member do
        # estas rutas mostraran los tweets y replies de un usuario especifico
        get 'tweets(/page/:page)', to: 'tweets#index', as: 'tweets'
        get 'tweets_and_replies(/page/:page)', to: 'tweets#tweets_and_replies', as: 'tweets_and_replies'
      end
    end

    # Rutas relacionadas con tweets del usuario actual y los que sigue
    # Get 'tweets', to: 'tweets#index_for_current_user'  # TweetsController#Index 
    # GET /tweets => tweets#index mostrara los tweets del usuario junto con los tweets de los usuarios que sigue. se redirige aqui al loguearse o registrarse using redirect_to
    # rutas en las que un current user puede interactuar con un determinado tweet
    resources :tweets, only: [ :index, :show, :create, :update, :new ] do
      member do
        post 'retweet'
        post 'quote'
        post 'like'
        delete 'unlike'
        post 'bookmark'
        get 'stats'
        post 'replies', to: 'tweets#create_reply'
      end
    end
  end
end