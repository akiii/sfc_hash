# -*- coding: utf-8 -*-
class WorksController < ApplicationController
  layout "works"

  include MySubjectsInfoHelper
  include WorksHelper

  def index
    @my_works = get_subject_teacher_url_array
  end

end
