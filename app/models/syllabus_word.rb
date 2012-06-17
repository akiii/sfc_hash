class SyllabusWord < ActiveRecord::Base
  belongs_to :subject_info

  attr_accessor :point
 
  def exist(string, subject_info)
    if SyllabusWord.find_by_string_and_subject_info_id(string, subject_info.id)
      return true
    else
      return false
    end
  end

  def set_point
    syllabus_words_count_include_string = SyllabusWord.find_all_by_subject_info_id_and_string(self.subject_info_id, self.string).count
    syllabus_words_count = SyllabusWord.find_all_by_subject_info_id(self.subject_info_id).count
    tf = syllabus_words_count_include_string * 1.0 / syllabus_words_count
    
    if !$syllabus_all_count
      $syllabus_all_count = SyllabusWord.group('subject_info_id').to_a.count
    end
    syllabus_count_include_string = SyllabusWord.where('string = ?', self.string).group('subject_info_id').to_a.count
    idf = Math::log($syllabus_all_count/syllabus_count_include_string)
    self.point = tf * idf
  end

end
