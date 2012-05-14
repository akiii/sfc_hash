class TweetsController < ApplicationController

  require 'twitter'

  def initialize
    Twitter.configure do |config|
      config.consumer_key = "q1L8GUOwCsFesni3iW6MBA"
      config.consumer_secret = "O0gzdm9t5TulVHUYMb6avRzHH8pKgNyFpmERb14IiQ4"
      config.oauth_token = "147903527-ikYXPzTGwBiiMxfkfeWeKjXOsmYlIofH1iB5D3jL"
      config.oauth_token_secret = "a7bHarLSoBLLnVQ4EVUmqK478IZolrWupTlkyUojM"
    end
  end

  def get_tweets_of_hashtags
    hashtags = Hashtag.all
    hashtags.each do |hashtag|
      get_tweets_of_hashtag(hashtag)
    end
  end

  def get_tweets_of_hashtag(hashtag)
    initialize
    tweets = Twitter.search(hashtag.string)
    save_tweets(tweets, hashtag)
  end

  def save_tweets(new_tweets, hashtag)
    new_tweets.each do |tweet|
      t = Tweet.new
      t.hashtag_id = hashtag.id
      t.from_user = tweet.from_user
      t.profile_image_url = tweet.profile_image_url
      t.text = tweet.text
      t.created_at = tweet.created_at
      t.save
    end
  end

end
