class Api::V1::EventTimesController < ApplicationController

  before_filter :authenticate_user_from_token!
  before_filter :authenticate_user!

  respond_to :json

  # return event time options for the specified event.
  def options
    # first check if user is signed
    if !user_signed_in?
      render :status => 401, :json => {:success => false, :errors => ["Unauthorized access"] }
    elsif Invitee.where(:event_id => params[:event_id], :user_id => current_user.id).count <= 0
      # user hasn't been invited to this event, so don't allow them to see time options for it
      render :status => 401, :json => {:success => false, :errors => ["Not authorized to view this event"] }
    else
      render :json => EventTimeOption.where(:event_id => params[:event_id]).as_json
    end
  end

  # return user's time choices for given event
  def index
    # first check if user is signed
    if !user_signed_in?
      render :status => 401, :json => {:success => false, :errors => ["Unauthorized access"] }
    elsif Invitee.where(:event_id => params[:event_id], :user_id => current_user.id).count <= 0
      # user hasn't been invited to this event, so don't allow them to see informatin about it
      render :status => 401, :json => {:success => false, :errors => ["Not authorized to view this event"] }
    else
      render :json => EventTimeUserChoice.joins(:event_time_option => :event)
                                         .where(:user_id => current_user.id, :events => {:id => params[:event_id]})
                                         .as_json
    end
  end

  # POST - params format is expected to be :event_time_user_choice => {:event_time_option_id => "1", :response => "true"}
  # user is determined via the api token
  def create
    if !user_signed_in?
      render :status => 401, :json => {:success => false, :errors => ["Unauthorized access"] }
    else
      event_time_option = EventTimeOption.find_by_id(params[:event_time_user_choice][:event_time_option_id])
      if event_time_option.nil?
        render :status => 404, :json => {:success => false, :errors => ["Invalid event time option"]}
      elsif Invitee.where(:event_id => event_time_option.event.id, :user_id => current_user.id).count <= 0
        render :status => 401, :json => {:success => false, :errors => ["Not authorized to view this event"] }
      else
        choice = EventTimeUserChoice.new(params[:event_time_user_choice])
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
