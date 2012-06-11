class MyWork
  attr_accessor :subject, :teacher, :title, :date, :situation, :didSubmission, :limitDate, :limitTime, :didSubmissionStudentCount

  def self.create(subject, teacher, title, date, situation, didSubmission, limitDate, limitTime, didSubmissionStudentCount)
    my_work = MyWork.new
    my_work.subject = subject
    my_work.teacher = teacher
    my_work.title = title
    my_work.date = date
    my_work.situation = situation
    my_work.didSubmission = didSubmission
    my_work.limitDate = limitDate
    my_work.limitTime = limitTime
    my_work.didSubmissionStudentCount = didSubmissionStudentCount
    return my_work
  end

end
