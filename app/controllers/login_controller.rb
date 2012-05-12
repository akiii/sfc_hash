#encoding: utf-8

class LoginController < ApplicationController

  require 'kconv'
  require 'httpclient'

  def submit
    client = HTTPClient.new
    data = {"u_login" => params[:u_login], "u_pass" => params[:u_pass]}
    id = client.post_content("https://vu9.sfc.keio.ac.jp/sfc-sfs/login.cgi", data)

    puts id
    if id =~ /url=(.+?)"/
      id =~ /id=(.+)&type/
      id = $1

      if User.where(:login_name => params[:u_login]).exists? then
        users = User.where(:login_name => params[:u_login])
        @user = users[0]
      else
        @user = User.new
        @user.login_name = params[:u_login]
        @user.user_name = params[:u_login]
	@user.save
      end

      reset_session
      session[:id] = @user.id
      save_student_id(id)

      redirect_to :controller => 'home', :action => 'index'
      return
    else
      flash[:error] = "ログイン名かパスワードが違います。"
      redirect_to :action => 'index'
    end
  end

end
