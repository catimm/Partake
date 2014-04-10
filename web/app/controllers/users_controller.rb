class UsersController < ApplicationController

  def show

    response = PackageResponse.where(:user_id => current_user)
    noresponse = PackageInstance.where{package_id.not_in response.select{package_instance_id}.uniq}
    @packages = noresponse.first

    Rails.logger.debug("My non-responses object: #{noresponse.inspect}")
    Rails.logger.debug("My displayed package object: #{@packages.inspect}")

    @response = PackageResponse.new
    @common = Common.new

    if @packages.nil?
      redirect_to thanks_path
    end
  end

  def update
    @response = PackageResponse.new(params[:package_response])
    if @response.save
      @friends = Friend.where(:user_id => current_user)
      @friends.each do |f|
        @shared = PackageResponse.where(:user_id => f.friend_id, :package_instance_id => params[:package_response][:package_instance_id], :response => "true")
        if !@shared.empty?
          @common = Common.create(:user_id => f.user_id, :friend_id => f.friend_id, :package_instance_id => params[:package_response][:package_instance_id])
        end
      end
      redirect_to user_path
    else
      redirect_to root_path
    end
  end
  
  def thanks
    @facebookuser = Authentication.where(:user_id => current_user)
    Rails.logger.debug("My object: #{@facebookuser.inspect}")
  end
end
