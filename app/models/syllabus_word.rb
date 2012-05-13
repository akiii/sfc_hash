class SyllabusWord < ActiveRecord::Base
  belongs_to :subject_info
 
  def exist(string, subject_info)
    if SyllabusWord.find_by_string_and_subject_info_id(string, subject_info.id)
      return true
    else
      return false
    end
  end

end
