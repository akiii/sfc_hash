class Tweet < ActiveRecord::Base

  validates :text, :uniqueness => true

end
