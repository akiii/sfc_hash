# -*- coding: utf-8 -*-
module TweetsHelper

  def get_tweets_from_subjects_info(subjects_info)
    hashtags = []
    tweets = []
    if subjects_info.count > 0
      subjects_info.each do |subject_info|
        hashtags << subject_info.hashtags
      end
      hashtags.flatten!
      hashtags.each do |hashtag|
        tweets << Tweet.find_all_by_hashtag_id(hashtag.id)
      end
      tweets.flatten!
      tweets = tweets.sort_by { |tweet| tweet.created_at }
      tweets.reverse!
    end
    tweets = Kaminari.paginate_array(tweets).page(params[:page]).per(10)
    return tweets
  end

  def get_tweets_of_hashtag(hashtag)
    initialize
    tweets = Twitter.search(hashtag.string)
    $hashtag_last_tweet_id = tweets[0].id
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

  def word_arr(tweet)
    word_arr = []
    mecab = MeCab::Tagger.new
    node = mecab.parseToNode(tweet.text)
    while node do
      if /名詞/u =~ node.feature.force_encoding("utf-8")
        word_arr << node.surface
      end
      node = node.next
    end
    return word_arr
  end

  def save_hashtag_canditate(tweets)
    tweets.each do |tweet|
      hashtag = hashtag_from_tweet(tweet)
      syllabus_words = []
      word_arr = word_arr(tweet)
      sws_all_count = SyllabusWord.all.count
      word_arr.each do |word|
        sws = SyllabusWord.find_all_by_string(word)
        sws_count = sws.count
        sws.each do |sw|
          sw.point = sws_all_count - sws_count
          syllabus_words << sw
        end
      end

      subject_info_and_point = Hash.new
      subject_info_and_point_arr = []
      syllabus_words.each do |syllabus_word|
        unless subject_info_and_point.key?(syllabus_word.subject_info)
          subject_info_and_point[syllabus_word.subject_info] = 0
        end
        subject_info_and_point[syllabus_word.subject_info] = subject_info_and_point[syllabus_word.subject_info] + syllabus_word.point
      end

      max_point = 0
      subject_info_and_point.to_a.sort_by{ |x, y|; [y, x]}.reverse.each do |key, max|
        if max_point < max
          max_point = max
        end
      end
      subject_info_and_point.each_pair do |key, value|
        unless value == max_point
          subject_info_and_point.delete(key)
        end
      end

      subject_info_and_point.each_pair do |key, value|
        hashtagCandidate = HashtagCandidate.find_by_string_and_subject_info_id(hashtag, key.id)
        if hashtagCandidate
          hashtagCandidate.point = hashtagCandidate.point + 1
        else
          hashtagCandidate = HashtagCandidate.new
          hashtagCandidate.string = hashtag
          hashtagCandidate.subject_info_id = key.id
          hashtagCandidate.point = 1
        end
        hashtagCandidate.save
      end
    end
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
