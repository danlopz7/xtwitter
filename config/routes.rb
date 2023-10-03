Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :tweets, only: [:create, :update], defaults: {format: :json} do
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

  resources :users, only: [] do
    get 'tweets(/page/:page)', to: 'tweets#index'
    get 'tweets_and_replies(/page/:page)', to: 'tweets#tweets_and_replies'
  end
end
