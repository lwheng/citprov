class PagesController < ApplicationController
  def home
    @title = "Home"
    @home = "active"
    @citation = ""
    @annotate = ""
    @about = ""
    @contact = ""
  end

  def citation
    @title = "Citation"
    @home = ""
    @citation = "active"
    @annotate = ""
    @about = ""
    @contact = ""
  end

  def annotate
    @title = "Annotate"
    @home = ""
    @citation = ""
    @annotate = "active"
    @about = ""
    @contact = ""
  end

  def about
    @title = "About"
    @home = ""
    @citation = ""
    @annotate = ""
    @about = "active"
    @contact = ""
  end

  def contact
    @title = "Contact"
    @home = ""
    @citation = ""
    @annotate = ""
    @about = ""
    @contact = "active"
  end

end
