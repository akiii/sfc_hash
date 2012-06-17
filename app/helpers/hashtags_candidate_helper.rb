# -*- coding: utf-8 -*-
module HashtagsCandidateHelper

  include TweetsHelper
  include TimetableHelper

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
    i = 0
    tweets.each do |tweet|
      start_time = Time.now
      timetable = get_timetable(tweet.created_at)
      if in_lectures(timetable)
      
        hashtag = hashtag_from_tweet(tweet)
        word_arr = word_arr(tweet)

        subject_info_point_hash = {}
        word_arr.each do |word|
	  sws = SyllabusWord.find(:all, :joins => :subject_info, :conditions => {:string => word, :subject_infos => {:timetable_id => Timetable.find_by_self(timetable).id}}, :group => 'subject_info_id')
          sws.each do |sw|
            sw.set_point
	    if sw.point != 0
#	      puts "#{sw.string} #{sw.subject_info.subject.name} #{sw.point}"
              if subject_info_point_hash[sw.subject_info]
                subject_info_point_hash[sw.subject_info] = subject_info_point_hash[sw.subject_info] + sw.point
              else
                subject_info_point_hash[sw.subject_info] = sw.point
              end
            end
          end
        end

        subject_info_point_hash_arr = subject_info_point_hash.to_a.sort do |a, b|
          (b[1] <=> a[1]) * 2 + (a[0] <=> b[0])
        end

        outs_hash = {}
        max_point = 0
        subject_info_point_hash_arr.each do |ele|
          if ele[1] >= max_point
            outs_hash[ele[0]] = ele[1]
	    max_point = ele[1]
          else
            break;
          end
        end

        outs_hash.each_pair do |key, value|
          hashtagCandidate = HashtagCandidate.find_by_string_and_subject_info_id(hashtag, key.id)
          if hashtagCandidate
            hashtagCandidate.point = hashtagCandidate.point + value
          else
            hashtagCandidate = HashtagCandidate.new
            hashtagCandidate.string = hashtag
            hashtagCandidate.subject_info_id = key.id
            hashtagCandidate.point = value
          end
#          hashtagCandidate.save
        end
      end
      end_time = Time.now
      puts "processing time : #{end_time - start_time} sec"
      i = i + 1
      puts "#{100.0 / tweets.count * i} %  done"
    end
  end

end
