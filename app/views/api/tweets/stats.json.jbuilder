# json.stats @tweet do
#     json.set! :retweets, get_retweets(@tweet.id).count
#     json.set! :quotes, get_quotes(@tweet.id).count
#     json.set! :likes, get_likes(@tweet.id).count
#     json.set! :bookmarks, get_bookmarks(@tweet.id).count
#   end


json.tweet do
  json.set! "tweet_#{@tweet.id}" do
    json.retweets @stats_response["tweet_#{@tweet.id}"][:retweets]
    json.quotes @stats_response["tweet_#{@tweet.id}"][:quotes]
    json.likes @stats_response["tweet_#{@tweet.id}"][:likes]
    json.bookmarks @stats_response["tweet_#{@tweet.id}"][:bookmarks]
  end
end