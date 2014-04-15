class Common < ActionMailer::Base
  
  def update(email, sent_at = Time.now)
      mail(:to => email, :from => 'info@wepartake.com', :subject => 'Partake food & drink options for you and your friends') do |format|
        format.html
        format.text
      end
   end
end
