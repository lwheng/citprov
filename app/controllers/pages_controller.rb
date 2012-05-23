class PagesController < ApplicationController
  def home
    @title = "Home"
  end

  def citation
    @title = "Citation"
  end

  def annotate
    @title = "Annotate"
  end

  def about
    @title = "About"
  end

  def contact
    @title = "Contact"
  end

end
