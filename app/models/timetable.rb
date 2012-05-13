# -*- coding: utf-8 -*-
class Timetable < ActiveRecord::Base

  def get_timetable_number_from_string(timetable_string)
    if timetable_string == '１'
      return 1
    elsif timetable_string == '２'
      return 2
    elsif timetable_string == '３'
      return 3
    elsif timetable_string == '４'
      return 4
    elsif timetable_string == '５'
      return 5
    elsif timetable_string == '６'
      return 6
    elsif timetable_string == '７'
      return 7
    end
  end

end
