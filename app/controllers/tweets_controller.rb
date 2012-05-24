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
#    initialize
#    tweets = Twitter.list_timeline("sfc_list", "sfc-all", options = {:since_id => $list_timeline_last_tweet_id })
#    $list_timeline_last_tweet_id = tweets[0].id
#    tweets = include_hashtag_tweets(tweets)
#    tweets.each do |tweet|
#      hashtag = hashtag_from_tweet(tweet)
#      save_hashtag_canditate(tweet, hashtag)
#    end
  end

  def get_and_croll_list_tweets(list_number, last_tweet_id)
    initialize
    listname = ""
    if list_number == 1
      list_name = "sfc-all"
    elsif list_number == 2
      list_name = "sfc-all2"
    end
    tweets = Twitter.list_timeline("sfc_list", list_name, options = {:since_id => last_tweet_id })
    if tweets.count > 0
      last_tweet_id = tweets[0].id
      tweets = include_hashtag_tweets(tweets)
      save_tweets_of_hashtag_candidate(tweets)
      save_hashtag_canditate(tweets)
    end
    return last_tweet_id
  end

  def croll_sfc_lists_timeline
    $last_tweet_id_of_tweets1 = get_and_croll_list_tweets(1, $last_tweet_id_of_tweets1)
    $last_tweet_id_of_tweets2 = get_and_croll_list_tweets(2, $last_tweet_id_of_tweets2)
  end

end
