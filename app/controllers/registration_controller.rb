class RegistrationController < ApplicationController
  layout "player"

  def index
    @tournaments = Tournament.tournaments_for_registration(session[:user_id])
  end
end
