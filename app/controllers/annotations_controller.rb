class AnnotationsController < ApplicationController
  def upload_data
    user = params[:user]
    annotation = params[:annotation]
    
    if Annotation.find_by_user(user).nil?
      # New user
      @annotation = Annotation.new(:user => user)
      @annotation.citation = Annotation.parse(annotation)
      @annotation.save
    else
      # Existing user
      @annotation = Annotation.find_by_user(user)
      @annotation.citation = Annotation.merge(@annotation.citation, Annotation.parse(annotation))
      @annotation.save
    end
    redirect_to(upload_path)
  end
  
  def upload
    @title = "Upload"
    @upload = "active"
  end

end
