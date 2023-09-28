Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :tweets, only: [:new, :create, :update] do
    member do
      get 'stats', to: 'tweets#stats'
      post 'like', to: 'tweets#like_tweet'
      delete 'like/:id', to: 'tweets#unlike_tweet'
      post 'bookmark', to: 'tweets#create_bookmark'
      delete 'bookmark/:id', to: 'tweets#delete_bookmark'
      post 'retweet', to: 'tweets#retweet_tweet'
      post 'reply', to: 'tweets#reply_tweet'
      post 'quote', to: 'tweets#quote_tweet'
    end
  end

  resources :users, only: [:id] do
    member do
      get 'tweets', to: 'users#get_tweets'
      get 'tweets_and_replies', to: 'users#get_tweets_and_replies'
    end
  end
end
