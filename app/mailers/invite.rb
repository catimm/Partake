class Invite < ActionMailer::Base

  def contact(contact, sent_at = Time.now)
      @contact = contact
      @user = User.find_by_id(@contact['user_id'])
      mail(:to => contact['friend_email'], :from => @user.email, :subject => 'Early user invite: join me at Partake!') do |format|
        format.html
        format.text
      end
   end
end