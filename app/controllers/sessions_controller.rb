class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(username: params[:session][:username])
    if user && user.authenticate(params[:session][:password])
      session[:user_id] = user.id
      flash[:notice] = "Hi #{user.username}! You are now logged in!"
      redirect_to root_path
    else
      flash.now[:danger] = "There is something wrong with either username or password"
      render :new
    end
  end

  def destroy
    session.delete(:user_id)
    flash[:notice] = "You've successfully logged out"
    redirect_to root_path
  end
end
