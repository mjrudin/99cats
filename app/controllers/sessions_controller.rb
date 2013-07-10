require 'securerandom'

class SessionsController < ApplicationController
  def new
    if params[:token] && User.find_by_session_token(params[:token])
      redirect_to cats_url
    else
      render :new
    end
  end

  def create
    username = params[:username]
    password = params[:password]

    u = User.where(:username => username, :password => password).first
    if u
      u.session_token = SecureRandom.base64
      u.save!

      session[:session_token] = u.session_token
      redirect_to cats_url
    else
      redirect_to new_session_url
    end
  end

  def destroy
    session_token = session[:session_token]
    u = User.find_by_session_token(session_token)

    u.session_token = nil
    u.save!
    session[:session_token] = nil

    redirect_to new_session_url

  end

end
