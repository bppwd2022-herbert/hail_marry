class HomeController < ApplicationController
  before_action :authenticate_user!
  #skip_before_action :require_no_authentication, only: [:new, :create]

  def index
    
  end
end
