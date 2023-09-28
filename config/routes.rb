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
    get 'tweets(/page/:page)', to: 'tweets#index'
    get 'tweets_and_replies(/page/:page)', to: 'tweets#tweets_and_replies'
  end
end


# These are some comments for me
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

# to: 'tweets#index' is not neccesary, we are defining that only: [:index] already goes to tweets#index
# /users/1/tweets/page/2
# /users/1/tweets_and_replies/page/2
# get 'page/:page', action: :index espera un segmento dinámico llamado :page que se puede acceder en el controlador a través de params[:page].
# action: :index: Esto indica que esta ruta debe dirigirse al método index del controlador asociado, que en este caso es el controlador TweetsController

#collection: Este especificador indica que la ruta personalizada es una acción de colección. En términos de Rails, 
# una acción de colección actúa sobre una colección de recursos (por ejemplo, una lista de tweets) en lugar de un recurso 
# específico (un tweet en particular). Las acciones de colección no requieren un ID específico de recurso en la URL.

# resources :users, only: [] do: We start by defining routes associated with the users resource, but the only: [] option 
# indicates that we don't want the default CRUD routes (like show, new, create, etc.) for the users resource. Anything inside 
# the block will belong to this resource and inherit its prefix.

# resources :tweets, only: [:index] do: Within the users resource definition, we define another resource, tweets, but we 
# only want the index route (i.e., a route to list all tweets). This setup generates a route to fetch tweets associated 
# with a specific user, like: /users/:user_id/tweets.

# collection do: This block defines routes that act on the entire collection rather than a specific member. 
# In the context of tweets, it's a way to specify routes that act on all tweets instead of a specific tweet.

# get 'page/:page', action: :index: Inside the collection block, we define a route to handle pagination. The generated 
# route will be /users/:user_id/tweets/page/:page, where :user_id is the user's ID and :page is the specific page number.
#  The :index action in the tweets controller will handle this route.

# get 'tweets_and_replies/page/:page', on: :member, to: 'tweets#tweets_and_replies': This line defines a route to 
# fetch tweets and replies of a specific user with pagination. 
# The generated route will look like: /users/:user_id/tweets_and_replies/page/:page. Here, on: :member indicates 
# that this route acts on a specific member (a specific user in this case) and not the entire collection of users.
#  The tweets_and_replies action in the tweets controller will handle this route.

# In summary, this code sets up routes to:

#   List tweets of a user: /users/:user_id/tweets
#   List tweets of a user with pagination: /users/:user_id/tweets/page/:page
#   List tweets and replies of a user with pagination: /users/:user_id/tweets_and_replies/page/:page.

