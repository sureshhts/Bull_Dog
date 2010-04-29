# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_bulldog_session',
  :secret      => '98ea5ec8c543b9e5242e5e0e7786518656e06b0b2a2a35b45faafe5dcdcab14d80546d3059c5cf7f371c9c88973d17e723827534e861dd4dd06352237ebaedbe'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
