json.array! @tweets, partial: 'api/tweets/tweet', as: :tweet

# 1. json.array!: Indica que estamos construyendo un arreglo JSON.
# 2. @tweets: Es la colección de tweets que se está procesando.
# 3. partial: 'api/tweets/tweet': Este es el camino al archivo parcial 
#    que describe cómo se debe presentar un tweet individualmente en la respuesta JSON. 
# 4. as: :tweet: Esta es una opción que le dice a Jbuilder qué nombre de variable usar 
#    dentro del archivo parcial. Entonces, en el archivo _tweet.json.jbuilder, usamos
#    tweet para referirnos al tweet actual que se está procesando.
# 4. as: :tweet: Es una variable local que se pasa al parcial. Esta variable representa 
#    un único tweet de la colección @tweets durante cada iteración.

# Usar un archivo parcial con Jbuilder es una forma de modularizar y reutilizar código.
# si cada tweet tiene una estructura específica que se repetirá en varias vistas o respuestas, 
# tiene sentido poner esa estructura en un archivo parcial (como _tweet.json.jbuilder),
# para evitar repetir el mismo código en varias vistas.

# El método json.array! de Jbuilder es inteligente y sabe cómo manejar colecciones (arrays). 
# Cuando se pasa una colección como el primer argumento (@tweets en este caso), Jbuilder itera 
# automáticamente sobre cada elemento de la colección y aplica el parcial (o la lógica 
# adicional que se haya especificado) a cada elemento.

# Dado este código, Jbuilder hará lo siguiente:

#     Tomará el primer tweet de @tweets.
#     Usará el parcial _tweet.json.jbuilder, pasando ese tweet como la variable local tweet.
#     Formateará la información de ese tweet usando el parcial.
#     Pasará al siguiente tweet y repetirá los pasos 1-3.
#     Continuará este proceso hasta que todos los tweets en @tweets hayan sido procesados.

# El resultado es un arreglo JSON donde cada tweet ha sido formateado de acuerdo con el parcial _tweet.json.jbuilder.
#  La cantidad de veces que lo hace es simplemente el número de tweets en @tweets.


# json.array! @tweets do |tweet|
#     json.extract! tweet, :id, :content, :created_at, :updated_at
#     json.user do
#       json.extract! tweet.user, :id, :username
#     end
# end

# json.array! @tweets do |tweet|
#     json.extract! tweet, :id, :user_id, :content, :retweet_id, :quote_id, :created_at, :updated_at
# end