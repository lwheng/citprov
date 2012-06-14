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
    if signed_in?
      @title = "Annotate"
      @annotate = "active"

      if session[:current_cite]
        # working currently
        # check whether no. of cites = 3
        cite_count = Annotation.find_by_cite_key(session[:current_cite].cite_key).users_count
        if cite_count == 3
          # reached 3, get a new one
          # check all citees of current cited first, before moving to next cited
          @citees = Annotation.get_citees(session[:current_cite].cite_key)
          if @citees
            # not nil, has cite_key (with same cited) with cite_count < 3
            # simply set to first one
            session[:current_cite] = Annotation.find_by_cite_key(@citees[0])
          else
            # all cite keys with same cited have cite_count = 3
            # fetch new cite key with new cited
            session[:current_cite] = Annotation.get_first
          end
        else
          # check whether already cited by current_user
          cite = Annotation.find_by_cite_key(session[:current_cite].cite_key)
          user = cite.user
          if user.keys.include?(current_user.username)
            # already cited for this cite_key
            # check all citees of current cited first, before moving to next cited
            @citees = Annotation.get_citees(session[:current_cite].cite_key)
            if @citees
              # not nil, has cite_key (with same cited) with cite_count < 3
              # get rid of the current one first
              @citees.delete(session[:current_cite].cite_key)
              session[:current_cite] = Annotation.find_by_cite_key(@citees[0])
            else
              # all cite keys with same cited have cite_count = 3
              # fetch new cite key with new cited
              session[:current_cite] = Annotation.get_first
            end
          else
            # have not cited for this cite_key, carry on
          end
        end
        # @current_key = session[:current_cite].cite_key
      else
        # just started
        # go fetch a near-3 cite_key
        session[:current_cite] = Annotation.get_first
        # @current_key = session[:current_cite].cite_key
      end
      @current_key = session[:current_cite].cite_key
    else
      redirect_to (annotate_start_path)
    end
  end

  def annotate_submit
    session[:annotate_error] = nil

    # Retrieve from params
    selection = params[:selection]
    type = params[:type]

    annotateType = ""
    specificDetails = ""
    case type["choice"]
    when "General"
      annotateType = "-"
    when "Specific"
      if selection.nil?
        session[:annotate_error] = "<div class='alert alert-error'><strong>Error!</strong></div>".html_safe
        redirect_to annotate_work_path
      end
      selection.keys.each do |line|
        specificDetails = "#{specificDetails}#{line}!"
      end
    when "Undetermined"
      annotateType = "?"
    end

    annotation = "#{session[:current_cite].cite_key},#{annotateType}#{specificDetails}"
    
    record = Annotation.find_by_cite_key(session[:current_cite].cite_key)
    record.user[current_user.username] = annotation
    record.users_count = record.users_count + 1
    @outcome = record.save

    # @annotate_submit_annotation = annotation
    # redirect_to(annotate_work_path)
  end

end
