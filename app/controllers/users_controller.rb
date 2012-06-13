class UsersController < ApplicationController
  def new
    @title = "Annotate"
    @annotate = "active"
  end
  
  def user
    @title = "Annotate"
    @annotate = "active"
    
    unless User.find_by_username(params[:username])
      @user = User.new(:username => params[:username])
      @user.save
    end
    
    # proceed to annotate
    redirect_to (annotate_work_path(@user))
  end
end
