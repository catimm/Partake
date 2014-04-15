class Api::V1::VenuesController < ApplicationController
  
  before_filter :authenticate_user_from_token!
  before_filter :authenticate_user!
 
  def index
    render :json => Venue.find(:all).as_json(:only => [:name, :cuisine, :phone,
      :website, :street, :city, :state, :zip, :hours1, :hours2, :hours3, :hours4])
  end
end
