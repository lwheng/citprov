class PagesController < ApplicationController
  def home
    @title = "Home"
    @home = "active"
  end

  def citation
    @title = "Citation"
    @citation = "active"
  end

  def about
    @title = "About"
    @about = "active"
  end

  def contact
    @title = "Contact"
    @contact = "active"
  end
  
  def classification
    @title = "Classification"
    @classification = "active"
  end
  
  def download
    @title = "Download"
    @download = "active"
  end
  
  def upload
    @title = "Upload"
    @upload = "active"
  end
  
  def annotate
    @title = "Annotate"
    @annotate = "active"
    
    @first_key = Annotation.get_first
  end
  
  def annotate_data
    selection = params[:selection]
    type = params[:type]
    username = params[:username]
    @annotate_data_selection = selection
    @annotate_data_type = type
    @annotate_data_username = username
    
    # redirect_to(annotate_path)
  end

end
