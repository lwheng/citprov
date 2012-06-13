class SessionsController < ApplicationController
  def new
    @title = "Annotate"
    @annotate = "active"
  end
  
  def create
    @title = "Annotate"
    @annotate = "active"
    
    @username = params[:username]
  end
  
  def destroy
  end

end
