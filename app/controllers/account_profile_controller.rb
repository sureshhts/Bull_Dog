class AccountProfileController < ApplicationController

layout "player"

  def myprofile
    @profile = AccountProfile.find(params[:id])
  end
end
