Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
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

  resources :users, only: [] do
    resources :tweets, only: [:index] do
      collection do 
        get 'page/:page', action: :index
      end
    end
    get 'tweets_and_replies/page/:page', on: :member, to: 'tweets#tweets_and_replies'
  end
end

# :new en las rutas de Rails se utiliza generalmente para mostrar un formulario para la creación de un nuevo recurso.

# Changed the routes for unliking and unbookmarking to not need an ID in the URL, since the combination 
# of logged-in user and tweet ID should be sufficient to find the relevant record to destroy.

# Replies: I created a nested resource for replies inside tweets. This makes sense because a reply is always associated with a specific tweet.

# member is to add another restful action. if it's only one member, I can do it like:
# http verb 'action', on: :member

# In order to find/see any user (him/her self included) tweets, I specified with 'only: []' that none of the default RESTful routes should be created for that resource.
# when you nest resources inside another resources, Rails will automatically expect the ID of the outer resource as a parameter.
# The 'only: []' option allows you to pick and choose which routes wil be created.
# resources :tweets, only: [:index], you're telling Rails to generate the route for listing all the tweets (i.e., the index action) and to skip routes for creating, updating, deleting, etc.

# controller: 'users/tweets'. ehmm need to do more research so I'm leaving the keyword to. just wanted to experiment with it.