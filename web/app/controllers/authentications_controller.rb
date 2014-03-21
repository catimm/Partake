class AuthenticationsController < ApplicationController

  def home
  end
  
  def facebook
    omni = request.env["omniauth.auth"]
    token = omni['credentials']['token']
    token_secret = omni['credentials']['secret']
    authentication = Authentication.find_by_provider_and_uid(omni['provider'], omni['uid'])
    registered = User.find_by_email(omni['info']['email'])
    
    
    
    Rails.logger.debug("My FB friends object: #{@current_friends.inspect}")
    
    if authentication
      # next 3 lines are configurations from koala gem
      @graph = Koala::Facebook::API.new(token) 
      profile = @graph.get_object("me")
      @current_friends = @graph.get_connections('me', 'friends?fields=name,id')
      # loop through each friend to add to db
      @current_friends.each do |f|
        friend = FbFriend.new
        friend.user_id = authentication.user_id
        friend.friend_name = f["name"]
        friend.friend_fbid = f["id"]
        already = FbFriend.find_by_user_id_and_friend_fbid(authentication.user_id, f["id"])
        if already
           flash[:notice] = "already a friend"
         else 
           friend.save
         end         
      end
      sign_in_and_redirect User.find(authentication.user_id)
    elsif registered
      # next 3 lines are configurations from koala gem
      @graph = Koala::Facebook::API.new(token) 
      profile = @graph.get_object("me")
      @current_friends = @graph.get_connections('me', 'friends?fields=name,id')
      # loop through each friend to add to db
      @current_friends.each do |f|
        friend = FbFriend.new
        friend.user_id = registered.id
        friend.friend_name = f["name"]
        friend.friend_fbid = f["id"]
        already = FbFriend.find_by_user_id_and_friend_fbid(registered.id, f["id"])
        if already
           flash[:notice] = "already a friend"
         else 
           friend.save
         end         
      end
      registered.authentications.create!(:provider => omni['provider'], :uid => omni['uid'], :token => token, :token_secret => token_secret)
      flash[:notice] = "Authentication successful"
      sign_in_and_redirect User.find(registered.id)
    else 
      user = User.new
      user.first_name = omni['info']['first_name']
      user.last_name = omni['info']['last_name']
      user.email = omni['info']['email']
      user.apply_omniauth(omni)
      
      if user.save
        # next 3 lines are configurations from koala gem
        @graph = Koala::Facebook::API.new(token) 
        profile = @graph.get_object("me")
        @current_friends = @graph.get_connections('me', 'friends?fields=name,id')
        # loop through each friend to add to db
        @current_friends.each do |f|
          friend = FbFriend.new
          friend.user_id = user.id
          friend.friend_name = f["name"]
          friend.friend_fbid = f["id"]
          already = FbFriend.find_by_user_id_and_friend_fbid(user.id, f["id"])
          if already
             flash[:notice] = "already a friend"
           else 
             friend.save
           end         
        end
        flash[:notice] = "Logged in."
        sign_in_and_redirect User.find(user.id)
      else
        session[:omniauth] = omni.except('extra')
        flash[:notice] = "Something went awry. Please try again."
        redirect_to new_user_registration_path
      end
    end
  end
end
