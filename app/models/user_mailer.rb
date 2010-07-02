class UserMailer < ActionMailer::Base

 def signup_notification(user)
    setup_email(user)
    @subject    += 'New account has been created'
    @body[:url]  = "http://tennis.hibiscustech.com"
  
 end
  
 def activation(user)
    setup_email(user)
    from		"BullDOg Tennis League"
    @subject    += 'Your account has been activated!'
    @body[:url]  = "http://YOURSITE/"
 end
 
 def forgot_password(recipient, sub, pwd)

    body["user"] = recipient.login
    body["email"] = recipient.email
    body["password"] = pwd
    body["userid"] = recipient.login
    recipients	recipient.login + " <" + recipient.email + ">"
    from		"BullDOg Tennis League"
    subject	    sub
   
    content_type "text/html"
    
  end 
 
 protected
 def setup_email(user)
      @recipients  = "#{user.email}"
      @from        = "BullDOg Tennis League"
      @subject     = "BullDog Tennis "
      @sent_on     = Time.now
      @body[:user] = user
 end  

end
