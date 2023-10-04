json.partial! 'api/tweets/tweet', tweet: @tweet
#json.url tweet_url(@tweet)

# 1. json.partial! 'api/tweets/tweet', tweet: @tweet - Esto carga el archivo parcial _tweet.json.jbuilder y le pasa el @tweet de la acción show a ese parcial bajo el nombre local tweet.

# 2. json.url tweet_url(@tweet) - Esto simplemente agrega el URL del tweet al objeto JSON final.

# Así, al acceder a la vista show, el resultado será un JSON construido a partir del archivo parcial _tweet.json.jbuilder más el campo url