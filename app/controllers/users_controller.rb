class UsersController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  
  layout 'default'
  include AuthenticatedSystem
  
   # render new.rhtml
  def new
    @user = User.new
    
     render :layout => 'default'
  end
 
  def create
    logout_keeping_session!
    @user = User.new(params[:user])
    @user.account_type = params[:user][:account_type]
  
    @user.time_created = Time.now.to_i
    success = @user && @user.save
    if success && @user.errors.empty?
            # Protects against session fixation attacks, causes request forgery
      # protection if visitor resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset session
      @user.update_attributes(:time_created => Time.now.to_i)
      self.current_user = @user # !! now logged in
     #redirect_back_or_default('/users/profile/<%= @user.id%>')
    
      @id = @user.id
    redirect_to :action => 'profile', :controller => 'users', :id => @id
      flash[:notice] = "Thanks for signing up!  We're sending you an email with your activation code."
    else
      flash[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact an admin (link is above)."
      redirect_to :action => 'new'
    end
     
  end
  
  def forgot_password
    if request.post?
      user = User.find(:first,:conditions=>["login=?", params[:user][:email]])
      if !user.nil? 
        new_pwd = newpass(8)  
        passphrase_digest = encrypt_password(new_pwd)
          username = user.login
          employee = User.find(:first, :conditions=> ["username=?", username])
        flag = employee.update_attributes(:hashed_password => passphrase_digest)   
        if flag

          # UserMailer.deliver_reset_password(user,new_pwd)
         # Mailer.deliver_forgot_password(user, "Your Password", new_pwd)
          flash[:notice] = "Your password has been reset."
          redirect_to :action => "home", :controller => "users"
        else
          flash[:notice] = "Your Password could not be changed."
          redirect_to :action =>"login", :controller => "users"
        end

      else 
        flash[:notice]="Email-id doesnt exists" 
      end   
    end 
  end
  
  def newpass( len )
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    newpass = ""
    1.upto(len) { |i| newpass << chars[rand(chars.size-1)] }
    return newpass
  end
  
  def profile
  
    render :layout => 'default'
  end
  
  def create_profile
  
     if params['commit']  == 'Cancel'
	   redirect_to :action => 'new'
	   return
     else
     end
     
    @profile = AccountProfile.create(params[:profile])
 	@id = @profile.user_id
  	if @profile.save
	   flash[:notice] =  'Account Profile Created Successfully'
	   redirect_to :action => 'acc_playing_details', :controller => 'users', :id => @id
	else
	   render :action => 'new'
	end
  
   
  end
  
  
  def acc_playing_details
    @facilties = Facility.find(:all)
    @level = PlayerLevel.find(:all)
  
   render :layout => 'default'
  end
  
  def create_playing_details
  	if params['commit']  == 'Cancel'
	   redirect_to :action => 'new'
	   return
    else
    end
    
    other_level = params[:account][:other_level]
    level = params[:account][:level_id]
    
    if level == 'other'
      @check = PlayerLevel.find(:all, :conditions => ["name=?", other_level])
      
      if !@dest.nil?
        flash[:notice] = "Player level already exists"
        redirect_to :action => "acc_playing_details", :id => params[:playing_details][:user_id]
      else
	      @level = PlayerLevel.create(:name => other_level)
	      new_level = @level.id
	      
	      @playing_details = AccountPlayingDetail.create(:player_level_id => new_level, :facility_id => params[:account][:facility_id], :user_id  => 	   	      params[:playing_details][:user_id])
	      
	      if @playing_details.save
		   flash[:notice] =  'Account Playing Details Created Successfully'
		   redirect_to :action => 'home', :controller => 'users'
		  end 
      end
   else  
    
	    @playing_details = AccountPlayingDetail.create(:player_level_id => params[:account][:level_id], :facility_id => params[:account][:facility_id],         	:user_id => params[:playing_details][:user_id])
	 
		
		if @playing_details.save
		   flash[:notice] =  'Account Playing Details Created Successfully'
		   redirect_to :action => 'home', :controller => 'users'
		else
			render :action => 'new'
		end
	end
  end
  
  def home
  	
  	render :layout => 'home'
  end
  
end
