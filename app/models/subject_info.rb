class SubjectInfo < ActiveRecord::Base
  belongs_to :term
  belongs_to :day
  belongs_to :timetable
  belongs_to :subject
  belongs_to :teacher
  belongs_to :room
  has_many :syllabus_words
  has_many :hashtags

  def exist(term, day, timetable, subject, teacher)
    subject = Subject.find_by_name(subject)
    teacher = Teacher.find_by_name(teacher)
    if subject && teacher
      subject_info = SubjectInfo.find_by_subject_id_and_teacher_id(subject.id, teacher.id)
      if subject_info
        if subject_info.day_id == Day.find_by_self(day).id && subject_info.timetable_id == Timetable.find_by_self(Timetable.new.get_timetable_number_from_string(timetable)).id
          return true
	else
	  return false
	end
      else
        return false
      end
    else
      return false
    end
  end

end
