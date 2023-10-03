if @retweet.persisted?
    json.partial! 'api/tweets/tweet', tweet: @retweet
  else
    json.errors ["You've already retweeted this tweet."]
  end