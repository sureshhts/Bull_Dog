class UsersController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  require 'digest/sha1'
 
  include AuthenticatedSystem
  
   # render new.rhtml
  def new
    @user = User.new
    
     render :layout => 'registration'
  end
  
  def about_us
  
   
  end
  
  def contact_us
  
  end
 
  def create
    logout_keeping_session!
   
    @user = User.new(params[:user])
    
    @user.account_type = params[:user][:account_type]
  
    @user.time_created = Time.now.to_i
    
    success = @user && @user.save
   
     @id = @user.id
    if success && @user.errors.empty? && @user.account_type == 'admin'
      # Protects against session fixation attacks, causes request forgery
      # protection if visitor resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset session
      @user.update_attributes(:time_created => Time.now.to_i)
      self.current_user = @user # !! now logged in
     #redirect_back_or_default('/users/profile/<%= @user.id%>')
        
      redirect_to :action => 'home', :controller => 'users'
      flash[:notice] = "Thanks for signing up..."
    elsif  success && @user.errors.empty? && @user.account_type == 'player'
     
	  redirect_to :action => 'profile', :controller => 'users', :id => @id
	  flash[:notice] = "Thanks for signing up!  We're sending you an email with your activation code."
	else
	  flash[:error]  = "We couldn't set up that account, sorry.  The Login or the Email already exists."
	  redirect_to :action => 'new'
	end
    
  end
  
  def forgot_password
    if request.post?
      user = User.find(:first,:conditions=>["email=?", params[:user][:email]])
      recipient= user.email
      if !user.nil? 
        new_pwd = newpass(8) 
          passphrase_digest = encrypted_password(new_pwd,user.salt)
          username = user.login
          employee = User.find(:first, :conditions=> ["login=?", username])
        flag = employee.update_attributes(:crypted_password => passphrase_digest)   
        if flag
          UserMailer.deliver_forgot_password(user, "Your Password", new_pwd)
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
  
  def newpass(len)
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    newpass = ""
    1.upto(len) { |i| newpass << chars[rand(chars.size-1)] }
    return newpass
  end
  
  def encrypted_password(password, salt)
	string_to_hash = password + salt
	Digest::SHA1.hexdigest(string_to_hash)
  end
  
  def profile
  
    render :layout => 'registration'
  end
  
  def create_profile
  
     if params['commit']  == 'Cancel'
	   redirect_to :action => 'new'
	   return
     else
     end
     
     puts 
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
  
   render :layout => 'registration'
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
	      
	      user_id = @playing_details.user_id
	      user_name = 
	      
	      if @playing_details.save
	       Mailer.deliver_signup_activation(user_id, self)
		   flash[:notice] =  'Account Playing Details Created Successfully'
		   redirect_to :action => 'home', :controller => 'users'
		  end 
      end
   else  
    
	    @playing_details = AccountPlayingDetail.create(:player_level_id => params[:account][:level_id], :facility_id => params[:account][:facility_id], :user_id => params[:playing_details][:user_id])
	 
		
		if @playing_details.save
		   flash[:notice] =  'Account Playing Details Created Successfully'
		   redirect_to :action => 'home', :controller => 'users'
		else
			render :action => 'new'
		end
	end
	
	
  end
  
  def home
  	@tournament = Tournament.open_tournaments
  	render :layout => 'home'
  end
  
  def new_acc
    
    render :layout => 'registration'
  end
  
  def index
   @user = User.find(:all, :conditions => ["account_type=?", "admin"])
   render :layout => 'default'
  end
  
  def edit_acc
  
    @user = User.find(params[:id])
    render :layout => 'default'
  end
  
  def update
   @user = User.find(params[:id])
  
   if @user.update_attributes(params[:user])
      flash[:notice] = 'Your changes are successfully updated.'
      redirect_to :action => 'index', :controller => 'users'
    else
     
    end
  end
  
  def change_password
    id = session[:user_id]
    render :layout => 'default'
  end
  
  def update_password
    if User.authenticate(current_user.login, params[:old_password])
       if ((params[:password] == params[:password_confirmation]) && !params[:password_confirmation].blank?)
       current_user.password_confirmation = params[:password_confirmation]
       current_user.password = params[:password]
                
        if current_user.save!
          flash[:notice] = "Password successfully updated"
          redirect_to :action => "home"
        else
          flash[:alert] = "Password not changed"
          render :action => 'change_password'
        end
                
       else
          flash[:alert] = "New Password mismatch" 
          render :action => 'change_password'
       end
    else
       flash[:alert] = "Old password incorrect" 
       render :action => 'change_password'
    end
  
  end
  
  def delete
  
    User.delete(params[:id])
  	redirect_to :controller => 'users', :action => 'index'
  end
  
  
 
end
