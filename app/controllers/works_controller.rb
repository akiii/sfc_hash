# -*- coding: utf-8 -*-
class WorksController < ApplicationController
  layout "works"

  include MySubjectsInfoHelper
  include WorksHelper

  def index
    get_student_id
    @my_works = get_subject_teacher_url_array
    @my_works.each do |my_work|
      puts my_work.title
    end
  end

end
