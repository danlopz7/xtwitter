class CreateTweets < ActiveRecord::Migration[7.0]
  def change
    create_table :tweets do |t|
      t.text :content
      t.integer :retweet_id
      t.integer :quote_id
      t.integer :comment_id
      t.belongs_to :user, null: false, foreign_key: true

      t.timestamps
    end

    add_foreign_key :tweets, :tweets, column: :retweet_id, on_delete: :cascade
    add_foreign_key :tweets, :tweets, column: :quote_id, on_delete: :cascade
    add_foreign_key :tweets, :tweets, column: :comment_id, on_delete: :cascade
  end
end
