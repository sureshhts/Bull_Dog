require 'digest/sha1'

class User < ActiveRecord::Base

  has_one :account_profile
  has_one :account_playing_detail
  has_many :tournament_players
  
  
  
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken

  validates_presence_of     :login
  validates_length_of       :login,    :within => 6..100
  validates_uniqueness_of   :login
  validates_format_of       :login,    :with => Authentication.email_regex, :message => Authentication.bad_email_message

  #validates_format_of       :name,     :with => Authentication.name_regex,  :message => Authentication.bad_name_message, :allow_nil => true
  #validates_length_of       :name,     :maximum => 100

  validates_presence_of     :email
  validates_length_of       :email,    :within => 6..100 #r@a.wk
  validates_uniqueness_of   :email
  validates_format_of       :email,    :with => Authentication.email_regex, :message => Authentication.bad_email_message
  
  validates_presence_of :account_type

  
  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :name, :password, :password_confirmation



  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  #
  # uff.  this is really an authorization, not authentication routine.  
  # We really need a Dispatch Chain here or something.
  # This will also let us return a human error message.
  #
  def self.authenticate(login, password)
    return nil if login.blank? || password.blank?
    u = find_by_login(login.downcase) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  def login=(value)
    write_attribute :login, (value ? value.downcase : nil)
    
  end

  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end

  def self.search_players(first_name, last_name)
    query = %Q{ select u.id, first_name, last_name
                from users u
                join account_profiles ap on ap.user_id = u.id
                where ap.first_name like '#{first_name}%' and ap.last_name like '#{last_name}%'}
    find_by_sql(query)
  end
  
    
  

end
