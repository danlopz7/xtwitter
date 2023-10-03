if @quote_tweet.persisted?
    json.partial! 'api/tweets/tweet', tweet: @quote_tweet
else
    json.errors @quote_tweet.errors.full_messages
end