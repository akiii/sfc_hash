module SearchHelper

  def search(subject, teacher, room, timetable, term)
    if subject
      if teacher
        if room
          if timetable
            if term
              return SubjectInfo.find_all_by_subject_id_and_teacher_id_and_room_id_and_timetable_id_and_term_id(subject.id, teacher.id, room.id, timetable.id, term.id)
            end
            return SubjectInfo.find_all_by_subject_id_and_teacher_id_and_room_id_and_timetable_id(subject.id, teacher.id, room.id, timetable.id)
          end
          return SubjectInfo.find_all_by_subject_id_and_teacher_id_and_room_id(subject.id, teacher.id, room.id)
        end
        return SubjectInfo.find_all_by_subject_id_and_teacher_id(subject.id, teacher.id)
      end
      return SubjectInfo.find_all_by_subject_id(subject.id)
    end
    if teacher
      if room
        if timetable
          if term
            return SubjectInfo.find_all_by_teacher_id_and_room_id_and_timetable_id_and_term_id(teacher.id, room.id, timetable.id, term.id)
          end
          return SubjectInfo.find_all_by_teacher_id_and_room_id_and_timetable_id(teacher.id, room.id, timetable.id)
        end
        return SubjectInfo.find_all_byteacher_id_and_room_id(teacher.id, room.id)
      end
      return SubjectInfo.find_all_by_teacher_id(teacher.id)
    end
    if room
      if timetable
        if term
          return SubjectInfo.find_all_by_room_id_and_timetable_id_and_term_id(room.id, timetable.id, term.id)
        end
        return SubjectInfo.find_all_by_room_id_and_timetable_id(room.id, timetable.id)
      end
      puts room.id
      return SubjectInfo.find_all_by_room_id(room.id)
    end
    if timetable
      if term
        return SubjectInfo.find_all_by_timetable_id_and_term_id(timetable.id, term.id)
      end
      return SubjectInfo.find_all_by_timetable_id(timetable.id)
    end
    if term
      return SubjectInfo.find_all_by_term_id(term.id)
    end
  end

end
