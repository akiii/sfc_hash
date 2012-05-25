class SearchController < ApplicationController
  before_filter :require_login

  include MySubjectsInfoHelper
  include SearchHelper
  include TweetsHelper

  def index
    @terms = [] 
    @days = []
    @timetables = []
    @subjects = []
    @teachers = []
    @rooms = []

    Term.all.each do |term|
      @terms << term.season
    end
    Day.all.each do |day|
      @days << day.self
    end
    Timetable.all.each do |timetable|
      @timetables << timetable.self
    end
    @all_subjects_info = SubjectInfo.all
    @all_subjects_info.each do |subject_info|
      @subjects << subject_info.subject.name
      @teachers << subject_info.teacher.name
    end
    Room.all.each do |room|
      @rooms << room.name
    end
    @subjects_info = $subjects_info
    unless $subjects_info
      @subjects_info = []
    end
    @tweets = get_tweets_from_subjects_info(@subjects_info)
  end

  def submit
    if params[:term]
      term = Term.find_by_season(params[:term])
    end
    if params[:day]
      day = Day.find_by_self(params[:day])
    end
    if params[:timetable]
      timetable = Timetable.find_by_self(params[:timetable])
    end
    if params[:subject]
      subject = Subject.find_by_name(params[:subject])
    end
    if params[:teacher]
      teacher = Teacher.find_by_name(params[:teacher])
    end
    if params[:room]
      room = Room.find_by_name(params[:room])
    end
    $subjects_info = search(subject, teacher, room, timetable, term)

    redirect_to :action => 'index'
  end

end
