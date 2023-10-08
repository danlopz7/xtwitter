if @tweet.persisted?
  json.tweet do
    json.partial! 'api/tweets/tweet', tweet: @tweet
  end
else
  json.errors @tweet.errors.full_messages
end

# Lo que está sucediendo aquí:

#     Usamos un condicional para verificar si @tweet fue guardado exitosamente en la base de datos. 
#     Si @tweet.persisted? devuelve true, entonces el tweet fue guardado correctamente.

#     Si el tweet fue guardado correctamente, usamos json.partial! 'api/tweets/tweet', tweet: @tweet 
#     para renderizar el tweet usando el archivo parcial _tweet.json.jbuilder que ya hemos definido.

#     Si el tweet no fue guardado correctamente, es decir, hubo errores de validación u otro problema,
#     entonces devolvemos @tweet.errors.full_messages como parte del objeto JSON bajo la clave errors.