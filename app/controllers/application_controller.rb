class ApplicationController < ActionController::Base
  protect_from_forgery

  private

  def check_administor
    if session[:id]
      if User.find(session[:id]).login_name != "t10740af"
        redirect_to :controller => "login", :action => "index"
      end
    end
  end

  def current_user
    @current_user ||= User.find(session[:id]) if session[:id]
  end

  def save_student_id(student_id)
    user = User.find(session[:id])
    user.session_id = student_id
    user.save
  end

  def get_student_id
    return User.find(session[:id]).session_id
  end

  def require_login
    unless current_user
      redirect_to :controller => "login", :action => "index"
    end
  end

end
