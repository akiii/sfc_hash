class Subject < ActiveRecord::Base
  has_many :subject_infos
  has_many :syllabus_words

  def exist(name)
    if Subject.find_by_name(name)
      return true
    else
      return false
    end
  end

end
