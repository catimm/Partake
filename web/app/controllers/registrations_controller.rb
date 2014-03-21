class RegistrationsController < Devise::RegistrationsController
  

    
    def build_resources(*args)
      super
      if session[:omniauth]
        @user.apply_omniauth(session[:omniauth])
        @user.valid?
      end
    end

  def after_sign_up_path_for(resource)
    @user = confirm_path
  end
  
  def after_inactive_sign_up_path_for(resource)
    @user = confirm_path
  end

   # Stripe.api_key = Figaro.env.stripe_api_key
   # token = params[:stripeToken]

    # build_resource(sign_up_params)

    # # first check if user is valid
    # if resource.invalid?
      # clean_up_passwords resource
      # respond_with resource
    # elsif token.blank? # this should never happen
      # clean_up_passwords resource
      # self.resource.errors[:base] << "There was an error with signing up. Please try again or contact us at #{Figaro.env.support_email}."
      # respond_with resource
    # else
      # # user is valid, so go ahead with stripe customer creation
      # stripe_error = ""
      # begin
        # customer = Stripe::Customer.create(
          # :card => token,
          # :email => resource.email
        # )
      # rescue Stripe::CardError => e
        # Rails.logger.error "Error creating Stripe customer: #{e.inspect}"
        # Rails.logger.error "error.to_s: #{e.to_s}"
        # stripe_error = e.json_body[:error][:message]
      # rescue => e
        # Rails.logger.error "Error creating Stripe customer: #{e.inspect}"
        # Rails.logger.error "error.to_s: #{e.to_s}"
        # stripe_error = "There was an error with the signup process. Please contact us at help@wepartake.com."
      # end

      # if !stripe_error.blank?
        # # error with stripe, let's bail
        # self.resource.errors[:base] << stripe_error
        # clean_up_passwords resource
        # respond_with resource
      # else
        # # this is copied from the 'create' method in base class since we need to set stripe customer id
        # resource.stripe_customer_id = customer.id
        # resource.role = 'registered' # this user is a registered one
        
        # if resource.save
          # if resource.active_for_authentication?
            # set_flash_message :notice, :signed_up if is_navigational_format?
            # sign_in(resource_name, resource)
            # respond_with resource, :location => after_sign_up_path_for(resource)
          # else
            # set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
            # expire_session_data_after_sign_in!
            # respond_with resource, :location => after_inactive_sign_up_path_for(resource)
          # end
        # else
          # clean_up_passwords resource
          # respond_with resource
        # end
      # end
    # end
  # end
end