class PagesController < ApplicationController
  def home
    @title = "Home"
    @home = "active"
  end

  def citation
    @title = "Citation"
    @citation = "active"
  end

  def annotate
    @title = "Annotate"
    @annotate = "active"
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
  
  def annotate_data
    selection = params[:selection]
    @annotate_data_test = selection
    
    # redirect_to(annotate_path)
  end

end
