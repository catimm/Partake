class EventsController < ApplicationController

  def show
    @invitee = Invitee.where(:event_id => params[:id], :uid => params[:uid]).first
    @event = Event.find_by_id(params[:id])
    if @invitee.nil? || @event.nil?
      render :file => "public/404", :status => 404
    else
      @package_options = EventPackageOption.where(:event_id => @event.id)
      @time_options = EventTimeOption.where(:event_id => @event.id)

      # add a placeholder image if the package doesn't have an image
      @package_options.each {|package_option|
        package = package_option.package_instance.package
        if package.image_url.blank?
          package.image_url = "https://s3-us-west-2.amazonaws.com/solutionprototype/venue/joule.jpg"
        end
      }
    end
  end

  def invite_response
    @invitee = Invitee.where(:event_id => params[:id], :uid => params[:uid]).first
    @event = Event.find_by_id(params[:id])
    if @invitee.nil? || @event.nil?
      render :file => "public/404", :status => 404
    else
      @package_options = EventPackageOption.where(:event_id => @event.id)
      @time_options = EventTimeOption.where(:event_id => @event.id)     
      if params[:accept] # unregistered user accepted
        respond_to_time_options(@time_options, @invitee.user, true)
        respond_to_package_options(@package_options, @invitee.user, true)
      else
        respond_to_time_options(@time_options, @invitee.user, false)
        respond_to_package_options(@package_options, @invitee.user, false)       
      end

      render :show
    end
  end

  private

  def respond_to_time_options(time_options, user, response)
    time_options.each { |time_option|
      # if user has responded before, just override their previous response
      time_choice = EventTimeUserChoice.where(:event_time_option_id => time_option.id, :user_id => user.id).first
      if time_choice.nil?
        time_choice = EventTimeUserChoice.new
        time_choice.user = user
        time_choice.event_time_option = time_option
      end
      time_choice.response = response
      time_choice.save!
    }
  end

  def respond_to_package_options(package_options, user, response)
    package_options.each { |package_option|
      # if user has responded before, just override their previous response
      package_choice = EventPackageUserChoice.where(:event_package_option_id => package_option.id, :user_id => user.id).first
      if package_choice.nil?
        package_choice = EventPackageUserChoice.new
        package_choice.user = user
        package_choice.event_package_option = package_option
      end
      package_choice.response = response
      package_choice.save!
    }   
  end
end
