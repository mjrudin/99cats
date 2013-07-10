class CatrentalrequestsController < ApplicationController
  before_filter :authenticate_user

  def new
    @cats = Cat.all
    render :new
  end

  def create
    begin
      CatRentalRequest.create!(params[:cat_rental_request])
      @cat_request = CatRentalRequest.last
      render :create
    rescue
      flash[:notices] ||= []
      flash[:notices] << "Invalid request!"
      @cats = Cat.all
      render :new
    end
  end

  def update
    request = CatRentalRequest.find(params[:id])
    request.update_attributes(params[:cat_rental_request])
    request.approve
    redirect_to cat_url(request.cat_id)
  end

end
