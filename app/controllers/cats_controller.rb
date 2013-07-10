class CatsController < ApplicationController
  before_filter :authenticate_user

  def index
    @cats = Cat.all
    render :index
  end

  def new
    render :new
  end

  def create
    params[:cat][:user_id] = User.find_by_session_token(session[:session_token]).id

    begin
      Cat.create!(params[:cat])
      render :create
    rescue
      flash[:notices] ||= []
      flash[:notices] << "Invalid request!"
      render :new
    end
  end

  def show
    @cat = Cat.find(params[:id])
    @owner = User.find_by_session_token(session[:session_token]).id == @cat.user_id
    @requests = CatRentalRequest.find_all_by_cat_id(params[:id])
    render :show
  end

  def edit
    @cat = Cat.find(params[:id])
    if User.find_by_session_token(session[:session_token]).id == @cat.user_id
      render :edit
    else
      render text: "Unauthorized", status: 418
    end
  end

  def update
    @cat = Cat.find(params[:id])
    @cat.update_attributes(params[:cat])
    redirect_to cat_url(@cat.id)
  end

  def destroy
    @cat = Cat.find_by_name_and_birthdate(params[:cat])
    if @cat
      @cat.delete
      render :destroy
    else
      render :index
    end
  end

end
