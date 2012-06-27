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
    
    if signed_in?
      if session[:current_cite]
        # Already there is cite_key
        # Check whether already annotated by current user
        result = Annotation.find_by_cite_key(session[:current_cite].cite_key)
        if result.annotations.keys.include?(current_user.username)
          # Already full-3. Get a new one.
          # Start with same cite_key with different context first
          results = Annotation.find(:all,
                                    :conditions => ["cite_key = ? AND annotation_count <> ?", session[:current_cite].cite_key, "3"],
                                    :order => "annotation_count DESC"
                                    )
          if results
            # To check whether each result is already annotated by current user
            results.each do |r|
              if !r.annotations.keys.include?(current_user.username)
                session[:current_cite] = r
                return
              end
            end
          end
          
          # All contexts are full-3. Get a new one
          # Try to maintain with same cited paper first. Get all citees of a cited paper
          results1 = Annotation.get_citees(session[:current_cite].cite_key)
          if results1
            # Check whether result annotated by current user
            results1.each do |r|
              if !r.annotations.keys.include?(current_user.username)
                session[:current_cite] = r
                return
              end
            end
          end
        else
          session[:current_cite] = result
          return       
        end
      end
      
      # No current cite yet. Get one
      temp = nil
      countList = [2,1]
      countList.each do |c|
        results = Annotation.get_first1(c)
        if results
          results.each do |r|
            if !r.annotations.keys.include?(current_user.username)
              session[:current_cite] = r
              return
            end
          end
        end
      end
      session[:current_cite] = Annotation.get_first1(0)
      return
    else
      redirect_to (annotate_start_path)
    end
      
    # if signed_in?
    #   if session[:current_cite]
    #     # working currently
    #     # check whether no. of cites = 3
    #     cite_count = Annotation.find_by_cite_key(session[:current_cite].cite_key).annotation_count
    #     if cite_count == 3
    #       # reached 3, get a new one
    #       # check all citees of current cited first, before moving to next cited
    #       @citees = Annotation.get_citees(session[:current_cite].cite_key)
    #       if @citees
    #         # not nil, has cite_key (with same cited) with cite_count < 3
    #         # simply set to first one
    #         session[:current_cite] = Annotation.find_by_cite_key(@citees[0])
    #       else
    #         # all cite keys with same cited have cite_count = 3
    #         # fetch new cite key with new cited
    #         session[:current_cite] = Annotation.get_first
    #       end
    #     else
    #       # check whether already cited by current_user
    #       cite = Annotation.find_by_cite_key(session[:current_cite].cite_key)
    #       annotations = cite.annotations
    #       if annotations.keys.include?(current_user.username)
    #         # already cited for this cite_key
    #         # check all citees of current cited first, before moving to next cited
    #         @citees = Annotation.get_citees(session[:current_cite].cite_key)
    #         if @citees
    #           # not nil, has cite_key (with same cited) with cite_count < 3
    #           # get rid of the current one first
    #           @citees.delete(session[:current_cite].cite_key)
    #           session[:current_cite] = Annotation.find_by_cite_key(@citees[0])
    #         else
    #           # all cite keys with same cited have cite_count = 3
    #           # fetch new cite key with new cited
    #           session[:current_cite] = Annotation.get_first
    #         end
    #       else
    #         # have not cited for this cite_key, carry on
    #       end
    #     end
    #     # @current_key = session[:current_cite].cite_key
    #   else
    #     # just started
    #     # go fetch a near-3 cite_key
    #     session[:current_cite] = Annotation.get_first
    #     # @current_key = session[:current_cite].cite_key
    #   end
    #   @current_key = session[:current_cite].cite_key
    # else
    #   redirect_to (annotate_start_path)
    # end
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
    record.annotations[current_user.username] = annotation
    record.annotation_count = record.annotation_count + 1
    @outcome = record.save

    # @annotate_submit_annotation = annotation
    # redirect_to(annotate_work_path)
  end

end
