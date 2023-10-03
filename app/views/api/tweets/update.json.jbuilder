json.tweet do
    json.extract! @tweet, :id, :user_id, :content, :retweet_id, :quote_id, :created_at, :updated_at
  end
  