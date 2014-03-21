class HomeController < ApplicationController
  
  def index  
    @request = Request.new
  end
  
  def create
    @request = Request.new(params[:request])  
    if @request.save
      redirect_to thanks_path
    else
      redirect_to root_path, :alert => "Please provide your name and email in correct format. Thanks!"
    end
 
  end
  
  def privacy
  end

  def terms
  end
  
  def thanks
  end

end
