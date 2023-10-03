json.extract! tweet, :id, :content, :user_id, :retweet_id, :quote_id, :created_at, :updated_at
#json.url tweet_url(tweet)

# Este archivo parcial extraería los atributos del tweet y también agregaría una URL para ese tweet específico.

# Al usar esta aproximación, puedes tener una representación consistente de un tweet en diferentes vistas 
# y también puedes hacer cambios en un solo lugar (el parcial) si alguna vez necesitas modificar cómo se 
# ve un tweet en la respuesta JSON. Es una forma de seguir el principio DRY (Don't Repeat Yourself) en las vistas.