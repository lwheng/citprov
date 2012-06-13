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

    @current_key = Annotation.get_first
    @cited = @current_key.split("==>")[1]
    # @citees = Citees.get_citees(@first_key)
  end

  def annotate_submit
    selection = params[:selection]
    type = params[:type]
    username = params[:username]
    current_key = params[:current_key]
    @annotate_submit_selection = selection
    @annotate_submit_type = type
    @annotate_submit_current_key = current_key

    # redirect_to(annotate_path)
  end

end
