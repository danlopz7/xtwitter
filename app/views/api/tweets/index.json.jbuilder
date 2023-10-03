json.array! @tweets, partial: 'api/tweets/tweet', as: :tweet

# 1. json.array!: Indica que estamos construyendo un arreglo JSON.
# 2. @tweets: Es la colección de tweets que se está procesando.
# 3. partial: 'api/tweets/tweet': Este es el camino al archivo parcial 
#    que describe cómo se debe presentar un tweet individualmente en la respuesta JSON. 
# 4. as: :tweet: Esta es una opción que le dice a Jbuilder qué nombre de variable usar 
#    dentro del archivo parcial. Entonces, en el archivo _tweet.json.jbuilder, puedes usar 
#    tweet para referirte al tweet actual que se está procesando.

# Usar un archivo parcial con Jbuilder es una forma de modularizar y reutilizar código.
# si cada tweet tiene una estructura específica que se repetirá en varias vistas o respuestas, 
# tiene sentido poner esa estructura en un archivo parcial (como _tweet.json.jbuilder),
# para evitar repetir el mismo código en varias vistas.


# json.array! @tweets do |tweet|
#     json.extract! tweet, :id, :content, :created_at, :updated_at
#     json.user do
#       json.extract! tweet.user, :id, :username
#     end
# end

# json.array! @tweets do |tweet|
#     json.extract! tweet, :id, :user_id, :content, :retweet_id, :quote_id, :created_at, :updated_at
# end