class PagesController < ApplicationController
  @title = ""
  @home = ""
  @citation = ""
  @annotate = ""
  @about = ""
  @contact = ""
  @classification = ""
  @download = ""
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

end
