class ApplicationController < ActionController::Base
  protect_from_forgery

  def current_user
    p "Session sesion token #{session[:session_token]}"
    p "User #{User.find_by_session_token(session[:session_token])}"
    @current_user ||= session[:session_token] &&
                      User.find_by_session_token(session[:session_token])
  end

  def logged_in?
    !!current_user
  end

  def authenticate_user
    unless logged_in?
      render text: "Unauthorized.", status: 418
    end
  end
end
