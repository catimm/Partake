class Api::V1::EventsController < ApplicationController

  before_filter :authenticate_user_from_token!
  before_filter :authenticate_user!
 
  respond_to :json
  
  def index
    if !user_signed_in?
      render :status => 401, :json => {:success => false, :errors => ["Unauthorized access"] }
    else
      result = Invitee.where(:user_id => current_user.id).map { |invitee|
        event_info = {
          :event_id => invitee.event.id,
          :organizer => {
            :first_name => invitee.event.organizer.first_name,
            :last_name => invitee.event.organizer.last_name,
            :email => invitee.event.organizer.email
          }
        }
  
        # check if event has been finalized yet
        if invitee.event.finalized_event.nil?
          # if user is the organizer, set status accordingly
          if invitee.event.organizer.id == current_user.id
            event_info[:status] = StatusMessages::InviteSent
          else 
            if invitee.accepted.nil?
              event_info[:status] = StatusMessages::ResponseDue
            elsif invitee.accepted
              event_info[:status] = StatusMessages::ResponseSent
            else # !invitee.accepted
              event_info[:status] = StatusMessages::DeclinedSent
            end
          end
        else
          # event is finalized
          if invitee.event.finalized_event.confirmed
            if invitee.accepted == false
              event_info[:status] = StatusMessages::DeclinedSent
            else
              event_info[:status] = StatusMessages::Confirmed
              event_info[:timestamp] = invitee.event.finalized_event.timestamp
            end
          else
            event_info[:status] = StatusMessages::Canceled
          end
        end

        event_info
      }
      render :json => result.as_json
    end
  end

  # show details for a particular event
  # depending on the state of the event (confirmed, canceled, still being planned),
  # the appropriate details are returned
  def show
    if !user_signed_in?
      render :status => 401, :json => {:success => false, :errors => ["Unauthorized access"] }
    else
      event = Event.find_by_id(params[:id])
      if event.nil?
        render :status => 404, :json => {:success => false, :errors => ["Event does not exist"] }
      else
        invitee = event.invitees.where(:user_id => current_user.id).first
        if invitee.nil?
          render :status => 401, :json => {:success => false, :errors => ["Not authorized to view this event"] }
        else
          event_info = {
            :event_id => event.id,
            :organizer => {
              :id => invitee.event.organizer.id,
              :first_name => invitee.event.organizer.first_name,
              :last_name => invitee.event.organizer.last_name,
              :email => invitee.event.organizer.email
            },
            :invitees => event.invitees.joins(:user).includes(:user).map {|invitee|
              {
                :user_id => invitee.user.id,
                :first_name => invitee.user.first_name,
                :last_name => invitee.user.last_name,
                :mobile_number => invitee.user.mobile_number,
                :email => invitee.user.email,
                :accepted => invitee.accepted
              }
            }
          }

          if event.finalized_event.nil?
            # event is not finalized, so send all options and their information
            event_info[:confirmed] = nil
            event_info[:time_options] = event.event_time_options.map {|time_option|
              {
                :id => time_option.id,
                :time => time_option.time,
                :upvotes => time_option.upvotes
              }
            }

            event_info[:package_options] = event.event_package_options.joins(:package_instance).includes(:package_instance).map {|package_option|
              {
                :package_instance_id => package_option.package_instance.id,
                :package_id => package_option.package_instance.package.id,
                :upvotes => package_option.upvotes,
                :price => package_option.package_instance.price,
                :title => package_option.package_instance.package.title,
                :description => package_option.package_instance.package.description,
                :image_url => package_option.package_instance.package.description
              }
            }
          elsif event.finalized_event.confirmed
            # event has been confirmed so just send details of the selected time and package option
            event_info[:confirmed] = true
            event_info[:time_option] = event.finalized_event.timestamp
            event_info[:package_option] = {
              :package_instance_id => event.finalized_event.package_instance.id,
              :package_id => event.finalized_event.package_instance.package.id,
              :price => event.finalized_event.package_instance.price,
              :title => event.finalized_event.package_instance.package.title,
              :description => event.finalized_event.package_instance.package.description,
              :image_url => event.finalized_event.package_instance.package.image_url             
            }
          else
            # event was canceled
            event_info[:confirmed] = false
          end

          render :json => event_info.as_json
        end
      end
    end
  end

  # POST - params format is expected to be 
  # {:invitees => [{:mobile_number, :email, :first_name, :last_name} ...], package_options => [id1, id2, ...], time_options => [time1, time2, ...]}
  # user is determined via the api token
  def create
    if !user_signed_in?
      render :status => 401, :json => {:success => false, :errors => ["Unauthorized access"] }
    else
      event = Event.new
      event.organizer = current_user

      ActiveRecord::Base.transaction do
        # create invitees
        invitees = params[:invitees] || []
        event.save!
        invitees.each {|invitee|
          user = User.find_by_mobile_number(invitee[:mobile_number])
          if user.nil?
            user = create_user invitee[:mobile_number], invitee[:email], invitee[:first_name], invitee[:last_name]
            # TODO anshuman 11/22/13 create unique URL to view event for non-registered users
          end

          create_invitee(event, user)
          # TODO anshuman 1/22/13 send notification to these users that they've been invited to a new event
        }

        # create event package options
        package_option_ids = params[:package_options] || []
        package_option_ids.each { |package_option_id|
          create_package_option(package_option_id, event)
        }

        # create event time options
        time_options = params[:time_options] || []
        time_options.each { |time|
          create_time_option(time, event)
        }
      end

      if event.persisted?
        render :status => 200, :json => {:success => true, :event_id => event.id}
      else
        render :status => 500, :json => {:success => false}
      end

    end
  end

  private
  def create_package_option(package_option_id, event)
    package_instance = PackageInstance.find(package_option_id) # raises exception if it doesn't exist, which is what we want
    event_package_option = EventPackageOption.new
    event_package_option.event = event
    event_package_option.package_instance = package_instance
    event_package_option.save!
  end

  def create_invitee(event, user)
    new_invitee = Invitee.new
    new_invitee.event = event
    new_invitee.user = user
    if user.role == UserRole::Unregistered
      new_invitee.uid = SecureRandom.hex(16)
    end
    new_invitee.save!
  end

  def create_user(mobile_number, email, first_name, last_name)
    user = User.new
    user.mobile_number = mobile_number
    user.email = email if !email.nil?
    user.first_name = first_name
    user.last_name = last_name
    user.role = "unregistered"
    user.save!
    return user
  end

  def create_time_option(time, event)
    event_time_option = EventTimeOption.new
    event_time_option.event = event
    event_time_option.time = DateTime.parse(time).utc
    event_time_option.save!
  end
end
