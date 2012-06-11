# -*- coding: utf-8 -*-
module WorksHelper

  require 'MySubject'
  require 'MyWork'

  def get_subject_teacher_url_array
    my_subjects = []
    my_works = []
    $client = HTTPClient.new
    url = "https://vu8.sfc.keio.ac.jp//sfc-sfs/sfs_class/student/view_timetable.cgi?id=" + get_student_id + "&term=2012s&fix=1&lang=ja"
    $client.get_content(url).split('\n').each do |page_row|
      page_row.toutf8.scan(/<a href="(.*?)" target="_blank">(.*?)\[(.*?)\]<\/a><br>\( (.*?) \)<br>/) do |url, subject, room, teacher|
        include_url = false
	my_subjects.each do |my_subject|
          if my_subject
            if !include_url && my_subject.url == url
              include_url = true
	    end
          end
	end
	if !include_url
          my_subject = MySubject.create(subject, teacher, url)
          my_subjects << my_subject
          works = get_works_array(my_subject)
          my_works << works
          my_works.flatten!
	end
      end
    end
    my_works = sort(my_works)
    return my_works;
  end

  def get_works_array(my_subject)
    works = []
    $client.get_content(my_subject.url).split('\n').each do |page_row|
      page_row = page_row.toutf8.gsub("\n", "")

      page_row.scan(/target=report>「(.*?)」<\/a><(.*?)>( ?)- (.*?)<span class=en>(.*?)<\/span><\/font><BR>　\(〆切<span class=en>deadline<\/span>: (.*?) (.*?), 提出者(.*?)名 <span class=en>/) do |title, str1, str2, situation, str3, date, time, didSubmissionStudentCount|
        didSubmission = false
        if /(.*?)提出済/ =~ situation
          didSubmission = true
        elsif /(.*?)未提出/ =~ situation
          didSubmission = false
        end
	works << MyWork.create(my_subject.subject, my_subject.teacher, title, date, situation, didSubmission, date, time, didSubmissionStudentCount.to_i)
      end

    end
    return works
  end

  def sort(my_works)
    arr = []
    my_works.each do |work|
      if work.didSubmission == true
        arr << work
      else
        arr.unshift(work)
      end
    end
    return arr
  end

end
