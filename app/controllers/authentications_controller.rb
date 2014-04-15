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
    
    if authentication # this section is to authenticate a user who has authenticated with FB before
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
    elsif registered # this section is to authenticate a user who is already registered but has not yet authenticated with FB
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
      # find other users who are friends
        @fbFriendFound = FbFriend.find_all_by_friend_fbid(omni['uid'])
        # loop through each friend to add to db
        @fbFriendFound.each do |f|
          friend = Friend.new
          friend.user_id = registered.id
          friend.friend_id = f["user_id"]
          friend.source = "facebook"
          friendAlready1 = Friend.find_by_user_id_and_friend_id(registered.id, f["user_id"])
          friendAlready2 = Friend.find_by_user_id_and_friend_id(f["user_id"], registered.id)
          if friendAlready1 || friendAlready2
             flash[:notice] = "already a friend"
           else 
             friend.save
           end         
        end
        @emailFriendFound = Contact.find_all_by_friend_email(omni['info']['email'])
        # loop through each friend to add to db
        @emailFriendFound.each do |f|
          friend = Friend.new
          friend.user_id = registered.id
          friend.friend_id = f["user_id"]
          friend.source = "email"
          friendAlready1 = Friend.find_by_user_id_and_friend_id(registered.id, f["user_id"])
          friendAlready2 = Friend.find_by_user_id_and_friend_id(f["user_id"], registered.id)
          if friendAlready1 || friendAlready2
             flash[:notice] = "already a friend"
           else 
             friend.save
           end         
        end
      flash[:notice] = "Authentication successful"
      sign_in_and_redirect User.find(registered.id)
    else # this section is for a user who has not yet registered for Partake and is using FB to do so
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
          fbFriend = FbFriend.new
          fbFriend.user_id = user.id
          fbFriend.friend_name = f["name"]
          fbFriend.friend_fbid = f["id"]
          already = FbFriend.find_by_user_id_and_friend_fbid(user.id, f["id"])
          if already
             flash[:notice] = "already a friend"
           else 
             fbFriend.save
           end         
        end
        # find other users who are friends
        @fbFriendFound = FbFriend.find_all_by_friend_fbid(omni['uid'])
        Rails.logger.debug("My fb friends found object: #{@fbFriendFound.inspect}")
        # loop through each friend to add to db
        @fbFriendFound.each do |f|
          friend = Friend.new
          friend.user_id = user.id
          friend.friend_id = f["user_id"]
          friend.source = "facebook"
          friendAlready1 = Friend.find_by_user_id_and_friend_id(user.id, f["user_id"])
          friendAlready2 = Friend.find_by_user_id_and_friend_id(f["user_id"], user.id)
          if friendAlready1 || friendAlready2
             flash[:notice] = "already a friend"
           else 
             friend.save
           end         
        end
        @emailFriendFound = Contact.find_all_by_friend_email(omni['info']['email'])
        # loop through each friend to add to db
        @emailFriendFound.each do |f|
          friend = Friend.new
          friend.user_id = user.id
          friend.friend_id = f["user_id"]
          friend.source = "email"
          friendAlready1 = Friend.find_by_user_id_and_friend_id(user.id, f["user_id"])
          friendAlready2 = Friend.find_by_user_id_and_friend_id(f["user_id"], user.id)
          if friendAlready1 || friendAlready2
             flash[:notice] = "already a friend"
           else 
             friend.save
           end         
        end
        flash[:notice] = "Logged in."
        sign_in_and_redirect User.find(user.id)
      elsen
        session[:omniauth] = omni.except('extra')
        flash[:notice] = "Something went awry. Please try again."
        redirect_to new_user_registration_path
      end
    end
  end
end
