class Subject < ActiveRecord::Base
  has_many :name, :uniq => true

  def exist(name)
    if Subject.find_by_name(name)
      return true
    else
      return false
    end
  end

end
