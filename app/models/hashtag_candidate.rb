class HashtagCandidate < ActiveRecord::Base

  belongs_to :subject_info
  has_many :subject_infos

end
