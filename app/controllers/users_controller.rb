
class UsersController < ApplicationController

  def new
    render :new
  end

  def create
    begin
      User.create!(params[:user])
      redirect_to new_session_url
    rescue
      flash[:notices] ||= []
      flash[:notices] << "Invalid request!"
      render :new
    end
  end
end
