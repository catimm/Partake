class PackageResponsesController < ApplicationController


def options
    @current_user = current_user
    m = User.new
    Rails.logger.debug("My user ID object: #{@current_user.inspect}")
    @packages = m.another_noresponse_provided
    Rails.logger.debug("My package object: #{@packages.inspect}")
    @response = PackageResponse.new

    if @packages.nil?
      redirect_to thanks_path
    end
  end
  
end
