class Api::V1::EventPackagesController < ApplicationController

  before_filter :authenticate_user_from_token!
  before_filter :authenticate_user!

  respond_to :json
 
  # return event package options for the specified event.
  def options
    # first check if user is signed
    if !user_signed_in?
      render :status => 401, :json => {:success => false, :errors => ["Unauthorized access"] }
    elsif Invitee.where(:event_id => params[:event_id], :user_id => current_user.id).count <= 0
      # user hasn't been invited to this event, so don't allow them to see package options for it
      render :status => 401, :json => {:success => false, :errors => ["Not authorized to view this event"] }
    else
      render :json => EventPackageOption.where(:event_id => params[:event_id]).map { |package_option|
        {
          :id => package_option.id,
          :venue_name => package_option.package_instance.package.venue.name,
          :venue_cuisine => package_option.package_instance.package.venue.cuisine,
          :venue_street => package_option.package_instance.package.venue.street,
          :venue_city => package_option.package_instance.package.venue.city,
          :venue_state => package_option.package_instance.package.venue.state,
          :venue_zip => package_option.package_instance.package.venue.zip,
          :package_type => package_option.package_instance.package.package_type,
          :description => package_option.package_instance.package.description,
          :start_time => package_option.package_instance.available_start_time,
          :end_time => package_option.package_instance.available_end_time,
          :price => package_option.package_instance.price,
          :advance_notice => package_option.package_instance.advance_notice
        }
      }.as_json
    end
  end

  # return user's package choices for given event
  def index
    # first check if user is signed
    if !user_signed_in?
      render :status => 401, :json => {:success => false, :errors => ["Unauthorized access"] }
    elsif Invitee.where(:event_id => params[:event_id], :user_id => current_user.id).count <= 0
      # user hasn't been invited to this event, so don't allow them to see informatin about it
      render :status => 401, :json => {:success => false, :errors => ["Not authorized to view this event"] }
    else
      render :json => EventPackageUserChoice.joins(:event_package_option => :event)
                                         .where(:user_id => current_user.id, :events => {:id => params[:event_id]})
                                         .as_json
    end
  end

  # POST - params format is expected to be :event_package_user_choice => {:event_package_option_id => "1", :response => "true"}
  # user is determined via the api token
  def create
    if !user_signed_in?
      render :status => 401, :json => {:success => false, :errors => ["Unauthorized access"] }
    else
      event_package_option = EventPackageOption.find_by_id(params[:event_package_user_choice][:event_package_option_id])
      if event_package_option.nil?
        render :status => 404, :json => {:success => false, :errors => ["Invalid event package option"]}
      elsif Invitee.where(:event_id => event_package_option.event.id, :user_id => current_user.id).count <= 0
        render :status => 401, :json => {:success => false, :errors => ["Not authorized to view this event"] }
      else
        choice = EventPackageUserChoice.new(params[:event_package_user_choice])
        choice.user = current_user
        if choice.save
          render :status => 200, :json => {:success => true}
        else
          respond_with choice
        end
      end
    end
  end
end
