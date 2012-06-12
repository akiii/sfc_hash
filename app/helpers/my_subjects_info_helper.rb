module MySubjectsInfoHelper

  require 'kconv'
  require 'httpclient'

  def add_subject_info_to_arr(my_subjects_info_arr, subject, teacher)
    if subject && teacher
      subject_info = SubjectInfo.find_by_subject_id_and_teacher_id(subject.id, teacher.id)
      unless my_subjects_info_arr.index(subject_info)
        my_subjects_info_arr << subject_info
      end
    end
    return my_subjects_info_arr
  end

  def my_subjects_info
    my_subjects_info_arr = []
    client = HTTPClient.new
    url = "https://vu8.sfc.keio.ac.jp/sfc-sfs/sfs_class/student/view_timetable.cgi?id=" + get_student_id + "term=2012s&fix=1&lang=ja"
    url = client.get_content(url).toutf8
    url.scan(/target="_blank">(.*?)\[(.*?)\]<\/a><br>\( (.*?) \)<br>/) do |subject, room, teacher|
      subject = "%" + subject + "%"
      teacher = "%" + teacher + "%"
      subject = Subject.find(:all, :conditions => ["name LIKE ?", subject])
      teacher = Teacher.find(:all, :conditions => ["name LIKE ?", teacher])
      if subject && teacher
        if subject.count >= 2
	  if teacher.count >= 2
	    subject.each do |sub|
	      teacher.each do |tea|
	        my_subjects_info_arr = add_subject_info_to_arr(my_subjects_info_arr, sub, tea)
              end
	    end
	  elsif teacher.count == 1
	    subject.each do |sub|
	      puts sub.id
	      puts teacher[0].id
	      my_subjects_info_arr = add_subject_info_to_arr(my_subjects_info_arr, sub, teacher[0])
	    end
	  end
	elsif subject.count == 1
	  if teacher.count >= 2
            teacher.each do |tea|
              my_subjects_info_arr = add_subject_info_to_arr(my_subjects_info_arr, subject[0], tea)
            end
          elsif teacher.count == 1
            my_subjects_info_arr = add_subject_info_to_arr(my_subjects_info_arr, subject[0], teacher[0])
          end
        end
      end
    end
    return my_subjects_info_arr
  end

end
