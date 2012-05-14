class Tweet < ActiveRecord::Base
  belongs_to :hashtag

  validates :text, :uniqueness => true
  default_scope :order => 'created_at DESC'
  paginates_per 10

end
