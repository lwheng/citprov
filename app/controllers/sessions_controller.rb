class SessionsController < ApplicationController
  def new
    @title = "Annotate"
    @annotate = "active"
    if signed_in?
      redirect_to annotate_work_path
    end
  end

  def create
    @title = "Annotate"
    @annotate = "active"

    @username = params[:session][:username]
    if @username.size > 0
      unless User.find_by_username(@username)
        @user = User.new(:username => @username)
        @user.save
      end
      @user = User.find_by_username(@username)
      sign_in (@user)
      redirect_to annotate_work_path
    else
      flash.now[:error] = "Invalid matric or ID"
      render 'new'
    end
  end

  def destroy
    # save the number of annotations done in this session
    md5 = User.generate_md5(current_user)
    noOfAnnotations = session[:noOfAnnotations]
    paid = false
    current_user.md5.push([md5, noOfAnnotations, paid])
    current_user.save
    sign_out
    redirect_to home_path
  end

end
