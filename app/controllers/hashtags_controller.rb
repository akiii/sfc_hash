class HashtagsController < ApplicationController
  before_filter :check_administor

  def index
    @subjects_info = SubjectInfo.all
  end

end
