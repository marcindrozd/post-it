class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :logged_in?, :current_user, :admin?, :can_edit?

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in?
    !!current_user
  end

  def require_user
    if !logged_in?
      redirect_to root_path
      flash[:error] = "You need to be logged in to do that!"
    end
  end

  def admin?
    current_user.role == "admin"
  end

  def require_admin
    display_alert unless logged_in? && admin?
  end

  def display_alert
    redirect_to root_path
    flash[:error] = "You can't do that!"
  end

  def can_edit?(post)
    post.creator == current_user || admin?
  end
end
