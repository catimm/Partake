class ContactsController < ApplicationController

  def show
    @contacts = request.env['omnicontacts.contacts']
    @contact = Contact.new
  end

  def failure
  end

  def create
    @contact = Contact.new(params[:contact])
    Rails.logger.debug("My contacts object: #{@contact.inspect}")
      
      respond_to do |format|
        if @contact.save
          Invite.contact(@contact).deliver
          format.html { redirect_to :back }
          format.js 
        else
          format.html { render action: "new" }
          format.json { render json: @contact.errors, status: :unprocessable_entity }
        end
    end
  end
  
end
