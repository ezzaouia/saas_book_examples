require_dependency "subscribem/application_controller"

module Subscribem
  class Account::DashboardController < ApplicationController
  	before_filter :authenticate_user!
  	def authenticate_user!
  	  unless user_signed_in?
  	    flash[:notice] = "Please sign in."
  	    redirect_to '/sign_in'
  	  end
  	end
  end
end
