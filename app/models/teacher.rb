class Teacher < ActiveRecord::Base
  has_many :name, :uniq => true

  def exist(name)
    if Teacher.find_by_name(name)
      return true
    else
      return false
    end
  end

end
