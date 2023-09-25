class CreateReplies < ActiveRecord::Migration[7.0]
  def change
    create_table :replies do |t|
      t.integer :id
      t.string :content
      t.integer :user_id
      t.integer :tweet_id
      t.integer :reply_id

      t.timestamps
    end
  end
end
