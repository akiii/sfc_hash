# -*- coding: utf-8 -*-
class TweetsController < ApplicationController

  require 'twitter'
  require 'MeCab'

  include TweetsHelper

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

  def get_hashtags_canditate
#    start_time = Time.now
    puts HashtagCandidate.all.count
    initialize
    tweets = Twitter.list_timeline("sfc_list", "sfc-all", options = {:since_id => $list_timeline_last_tweet_id })
    $list_timeline_last_tweet_id = tweets[0].id
#    tweets = Tweet.all
    tweets = include_hashtag_tweets(tweets)
    tweets.each do |tweet|
#      hashtag = hashtag_from_tweet(tweet)
#      save_hashtag_canditate(tweet, hashtag)
    end
#    end_time = Time.now
#    puts "処理概要:#{(end_time - start_time).to_s}s"
  end

end
