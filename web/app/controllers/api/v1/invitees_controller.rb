class Api::V1::InviteesController < ApplicationController

  before_filter :authenticate_user_from_token!
  before_filter :authenticate_user!
 
  respond_to :json

  # respond to an invitation for an event
  # request body format:
  # {
  #   :accepted => true | false, 
  #   :time_choices => [{:time_option_id1, :response}, {:time_option_id2, :response}, ...],
  #   :package_choices =>[{:package_option_id1, :response}, {:package_option_id2, :response}]
  # }
  # where :accepted is boolean
  def update
    if !user_signed_in?
      render :status => 401, :json => {:success => false, :errors => ["Unauthorized access"] }
    else
      event = Event.find_by_id(params[:event_id])
      if event.nil?
        render :status => 404, :json => {:success => false, :errors => ["Event does not exist"] }
      else
        invitee = event.invitees.where(:user_id => current_user.id).first
        if invitee.nil?
          render :status => 401, :json => {:success => false, :errors => ["Not authorized to respond to this event"] }
        else
          ActiveRecord::Base.transaction do
            invitee.accepted = params[:accepted]
            invitee.save!

            # if the invitee is the organizer, then cancel the event
            if invitee.user == event.organizer && !invitee.accepted
              finalized_event = FinalizedEvent.new
              finalized_event.event = event
              finalized_event.confirmed = false
              finalized_event.timestamp = DateTime.now.utc
              finalized_event.save!
            end

            # if user is declining, then make sure to respond in the negative for any previous options they gave
            # even if the user is the organizer of the event
            if !invitee.accepted
              EventTimeUserChoice.joins(:event_time_option).where('event_time_options.event_id' => event.id).readonly(false).each { |choice|
                choice.response = false
                choice.save!
              }

              EventPackageUserChoice.joins(:event_package_option).where('event_package_options.event_id' => event.id).readonly(false).each { |choice|
                choice.response = false
                choice.save!
              }
            elsif !params[:time_choices].nil?
              # save their time choices first
              params[:time_choices].each { |time_choice|
                time_option = EventTimeOption.find_by_id(time_choice[:time_option_id])
                # TODO anshuman 12/20/2013 Should we error out if it's an invalid time option?
                # We'll ignore for now
                if time_option.nil?
                  next
                end
                user_time_choice = EventTimeUserChoice.where(
                  :user_id => current_user.id,
                  :event_time_option_id => time_choice[:time_option_id]
                  ).first
                if user_time_choice.nil?
                  user_time_choice = EventTimeUserChoice.new do |choice|
                    choice.user_id = current_user.id
                    choice.event_time_option_id = time_choice[:time_option_id]
                  end
                end

                user_time_choice.response = time_choice[:response]
                user_time_choice.save!
              }
            end

            if !params[:package_choices].nil?
              # now save package choices
              params[:package_choices].each { |package_choice|
                package_option = EventPackageOption.find_by_id(package_choice[:package_option_id])
                # TODO anshuman 12/20/2013 Should we error out if it's an invalid package option?
                # same problem as with time option above
                # We'll ignore for now
                if package_option.nil?
                  next
                end
                user_package_choice = EventPackageUserChoice.where(
                  :user_id => current_user.id,
                  :event_package_option_id => package_choice[:package_option_id]
                  ).first
                if user_package_choice.nil?
                  user_package_choice = EventPackageUserChoice.new do |choice|
                    choice.user_id = current_user.id
                    choice.event_package_option_id = package_choice[:package_option_id]
                  end
                end

                user_package_choice.response = package_choice[:response]
                user_package_choice.save!
              }
            end

            render :status => 200, :json => {:success => true}
          end
        end
      end
    end
  end

end
