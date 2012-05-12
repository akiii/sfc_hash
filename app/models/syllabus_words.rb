class SyllabusWords < ActiveRecord::Base

  belongs_to :subject

  def exist(string, subject_id)
    if SyllabusWords.find_by_string_and_subject_id(string, subject_id)
      return true
    else
      return false
    end
  end

end
