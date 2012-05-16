class Hashtag < ActiveRecord::Base
  belongs_to :subject_info
  has_many :tweets

  validates :string,
    :length => { :minimum => 1, :maximum => 30 },
    :format => { :with => /^#(.+?)$/ }
end
