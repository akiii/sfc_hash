# -*- coding: utf-8 -*-
module TweetsHelper

  def get_tweets_from_subjects_info(subjects_info)
    hashtags = []
    tweets = []
    subjects_info.each do |subject_info|
      if subject_info
        hashtags << subject_info.hashtags
      end
    end
    hashtags.flatten!
    hashtags.each do |hashtag|
      tweets << Tweet.find_all_by_hashtag_id(hashtag.id)
    end
    tweets.flatten!
    tweets = tweets.sort_by { |tweet| tweet.created_at }
    tweets.reverse!
    tweets = Kaminari.paginate_array(tweets).page(params[:page]).per(10)
    return tweets
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

  def hashtag_from_tweet(tweet)
    words = tweet.text.split("\s")
    if words.count >= 2
      words.each do |word|
        if /(#(.+)?)/ =~ word
          # hashtag exist
          # puts "hashtag : #{$1}"
          return $1
        end
      end
    end
    return nil
  end

  def include_hashtag_tweets(tweets)
    hashtag_tweets = []
    c = 0
    tweets.each do |tweet|
      if hashtag_from_tweet(tweet)
        c = c +1
        unless hashtag_tweets.index(tweet)
          hashtag_tweets << tweet
        end
      end
    end
    return hashtag_tweets
  end

  def save_tweets_of_hashtag_candidate(tweets)
    tweets.each do |tweet|
      hashtag_candidate_tweet = HashtagCandidateTweet.new
      hashtag_candidate_tweet.text = tweet.text
      hashtag_candidate_tweet.created_at = tweet.created_at
      hashtag_candidate_tweet.save
    end
  end

end
