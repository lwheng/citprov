class AnnotationsController < ApplicationController
  def upload_data
    user = params[:user]
    annotation = params[:annotation]
    @annotation = Annotation.new(:user => user)
    @annotation.citation = Annotation.parse(annotation)
    @annotation.save
    redirect_to(upload_path)
  end
  
  def upload
  end

end
