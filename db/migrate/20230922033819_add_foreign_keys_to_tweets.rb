class AddForeignKeysToTweets < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :tweets, :tweets, column: :retweet_id
    add_foreign_key :tweets, :tweets, column: :quote_id

    # Estas líneas agregan restricciones de clave foránea a las columnas "retweet_id" y 
    # "quote_id" en la tabla "Tweets", estableciendo que estos campos deben hacer referencia 
    # a otras filas en la misma tabla "Tweets" (self-referenciales). Esto se utiliza para 
    # representar retweets y quoting tweets.
  end
end
