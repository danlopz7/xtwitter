class CreateJoinTableHashtagsTweets < ActiveRecord::Migration[7.0]
  def change
    create_join_table :hashtags, :tweets do |t|
      # t.index [:hashtag_id, :tweet_id]
      # t.index [:tweet_id, :hashtag_id]
    end
  end
end
