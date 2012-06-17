# -*- coding: utf-8 -*-
module TimetableHelper

  def get_timetable(time)
    time_arr = time.to_a
    hour = time_arr[2]
    min = time_arr[1]
    mins = hour * 60 + min
    start_times = [[9, 25], [11, 10], [13, 0], [14, 30], [16, 30], [18, 10]]
    for i in 0..start_times.count - 1
      start_time_min = start_times[i][0] * 60 + start_times[i][1]
      finish_time_min = start_time_min + 90
      if start_time_min <= mins && mins <= finish_time_min
        return i + 1
      end
    end
    return 0
  end

  def in_lectures(timetable)
    if 1 <= timetable && timetable <= 6
      return true
    else
      return false
    end
  end

  def day(time)
    wdays = ["日", "月", "火", "水", "木", "金", "土"]
    time_arr = time.to_a
    return Day.find_by_self(wdays[time_arr[6]])
  end

end
