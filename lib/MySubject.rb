class MySubject
  attr_accessor :subject, :teacher, :url

  def self.create(subject, teacher, url)
    my_subject = MySubject.new
    my_subject.subject = subject
    my_subject.teacher = teacher
    my_subject.url = url
    return my_subject
  end

end
