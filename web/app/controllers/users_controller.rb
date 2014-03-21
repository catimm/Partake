class UsersController < ApplicationController

  def show

    response = PackageResponse.where(:user_id => current_user)
    noresponse = PackageInstance.where{id.not_in response.select{package_instance_id}.uniq}
    @packages = noresponse.first

    Rails.logger.debug("My non-responses object: #{response.inspect}")
    Rails.logger.debug("My non-responses object: #{noresponse.inspect}")
    Rails.logger.debug("My displayed package object: #{@packages.inspect}")

    @response = PackageResponse.new

    if @packages.nil?
      redirect_to thanks_path
    end
  end

  def update
    @response = PackageResponse.new(params[:package_response])
    Rails.logger.debug("My object: #{@response.inspect}")
    if @response.save
      redirect_to user_path
    else
      redirect_to root_path
    end
  end
end
