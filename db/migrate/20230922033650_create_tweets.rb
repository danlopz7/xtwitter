class CreateTweets < ActiveRecord::Migration[7.0]
  def change
    create_table :tweets do |t|
      t.references :user, null: false, foreign_key: true
      t.string :content
      t.integer :retweet_id
      t.integer :quote_id

      # retweet_id y quote_idSon columnas enteras que pueden contener el ID de otro tweet en la misma tabla

      t.timestamps
    end
  end
end
