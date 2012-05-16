# -*- coding: utf-8 -*-
class HomeController < ApplicationController
  before_filter :require_login

  include MySubjectsInfoHelper

  def index
    @subjects_info = my_subjects_info
    @tweets = []
    hashtags = Hashtag.all
    hashtags.each do |hashtag|
      if hashtag.tweets.count >= 2
        hashtag.tweets.each do |tweet|
          @tweets << tweet
	end
      elsif hashtag.tweets.count == 1
        @tweets << hashtag.tweets
      end
    end
    @tweets.sort_by { |tweet| tweet.created_at }
    @tweets = Kaminari.paginate_array(@tweets).page(params[:page]).per(10)

  end
  def add
    @subject_info = SubjectInfo.find(params[:subject_info_id])
    @room = Room.all
  end

  def edit

  end

  def submit
    subject_info = SubjectInfo.find(params[:subject_info_id])
    subject_info.room_id = Room.find(params[:room]).id
    subject_info.save
    if /^#(.+?)$/ =~ params[:hashtag][:string]
      hashtag = Hashtag.new
      if Hashtag.find_by_string(params[:hashtag][:string])
        hashtag = Hashtag.find_by_string(params[:hashtag][:string])
      end
      hashtag.string = params[:hashtag][:string]
      hashtag.subject_info_id = params[:subject_info_id]
      hashtag.save
    else
      flash[:error] = "ハッシュタグが正しくありません。"
      redirect_to :action => 'add', :subject_info_id => params[:subject_info_id]
      return
    end

    if params[:state] == 'add'

    elsif params[:state] == 'edit'

    end

    redirect_to :action => 'index'
  end

  def logout
    session[:id] = nil
    redirect_to :controller => 'login', :action => 'index'
  end

end
