class Subject < ActiveRecord::Base

  def exist(name)
    if Subject.find_by_name(name)
      return true
    else
      return false
    end
  end

end
