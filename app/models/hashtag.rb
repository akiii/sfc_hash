class Hashtag < ActiveRecord::Base
  belongs_to :subject_info

    validates :hashtag,
      :length => { :minimum => 1, :maximum => 30 },
      :format => { :with => /^#(.+?)$/ }
end
