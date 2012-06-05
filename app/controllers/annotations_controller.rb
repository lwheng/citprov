class AnnotationsController < ApplicationController
  def upload_data
    user = params[:user]
    annotation = params[:annotation]
    
    citations = Annotation.parse(user, annotation)
    citations.keys.each do |key|
      if Annotation.find_by_cite_key(key).nil?
        @annotation = Annotation.new(:cite_key => key)
        @annotation.user = citations[key]
        @annotation.save
        # New key in database
      else
        # Existing key
        @annotation = Annotation.find_by_cite_key(key)
        @annotation.user[user] = citations[key][user]
        @annotation.save
      end
    end
    redirect_to(upload_path)
  end
  
  def upload
    @title = "Upload"
    @upload = "active"
  end

end
