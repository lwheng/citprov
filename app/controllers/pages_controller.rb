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
        result = Annotation.find_by_id(session[:current_cite].id)
        if result.annotation_count < 3
          if !result.annotations.keys.include?(current_user.username)
            session[:current_cite] = result
            return
          end
        end
        # Current context already cited 3 times
        # Try another context first
        results = Annotation.find(:all,
                                  :conditions => ["cite_key = ? and annotation_count <> ? and id <> ?", result.cite_key, 3, result.id],
                                  :order => "annotation_count DESC")
        results.each do |r|
          if !r.annotations.keys.include?(current_user.username)
            session[:current_cite] = r
            return
          end
        end
      end

      # No current_cite, get one
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
      redirect_to(annotate_start_path)
    end
    
    # if signed_in?
    #   if session[:current_cite]
    #     # Already there is cite_key
    #     # Check whether already annotated by current user
    #     result = Annotation.find_by_cite_key(session[:current_cite].cite_key)
    #     if result.annotations.keys.include?(current_user.username)
    #       # Already full-3. Get a new one.
    #       # Start with same cite_key with different context first
    #       results = Annotation.find(:all,
    #                                 :conditions => ["cite_key = ? AND annotation_count <> ?", session[:current_cite].cite_key, "3"],
    #                                 :order => "annotation_count DESC"
    #                                 )
    #       if results
    #         # To check whether each result is already annotated by current user
    #         results.each do |r|
    #           if !r.annotations.keys.include?(current_user.username)
    #             session[:current_cite] = r
    #             return
    #           end
    #         end
    #       end
          
    #       # All contexts are full-3. Get a new one
    #       # Try to maintain with same cited paper first. Get all citees of a cited paper
    #       results1 = Annotation.get_citees(session[:current_cite].cite_key)
    #       if results1
    #         # Check whether result annotated by current user
    #         results1.each do |r|
    #           if !r.annotations.keys.include?(current_user.username)
    #             session[:current_cite] = r
    #             return
    #           end
    #         end
    #       end
    #     else
    #       session[:current_cite] = result
    #       return       
    #     end
    #   end
      
    #   # No current cite yet. Get one
    #   temp = nil
    #   countList = [2,1]
    #   countList.each do |c|
    #     results = Annotation.get_first1(c)
    #     if results
    #       results.each do |r|
    #         if !r.annotations.keys.include?(current_user.username)
    #           session[:current_cite] = r
    #           return
    #         end
    #       end
    #     end
    #   end
    #   session[:current_cite] = Annotation.get_first1(0)
    #   return
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
        session[:annotate_error] = "<div class='alert alert-error'><strong>Error! You did not select any lines for a Specific citation</strong></div>".html_safe
        redirect_to(annotate_work_path)
        return
      end
      selection.keys.each do |line|
        specificDetails = "#{specificDetails}#{line}!"
      end
    when "Undetermined"
      annotateType = "?"
    end

    annotation = "#{session[:current_cite].cite_key},#{annotateType}#{specificDetails}"
    
    recordAnnotation = Annotation.find_by_id(session[:current_cite].id)
    recordAnnotation.annotations[current_user.username] = annotation
    recordAnnotation.annotation_count = recordAnnotation.annotation_count + 1
    
    # recordUser = User.find_by_username(current_user.username)
    # if !recordUser.annotations
    #   recordUser.annotations = {}
    # end
    # recordUser.annotations[session[:current_cite].cite_key] = "#{annotateType}#{specificDetails}"
    # if recordUser.new_annotation_count
    #   recordUser.old_annotation_count = recordUser.new_annotation_count
    # else
    #   recordUser.new_annotation_count = 0
    # end
    
    # @outcome = recordAnnotation.save
    # recordUser.save
    
    if !current_user.annotations
      current_user.annotations = {}
    end
    current_user.annotations["#{session[:current_cite].cite_key}##{session[:current_cite].id}"] = "#{annotateType}#{specificDetails}"
    if current_user.new_annotation_count.nil?
      current_user.new_annotation_count = 0
    end
    
    current_user.new_annotation_count = current_user.new_annotation_count + 1
    if !session[:noOfAnnotations]
      session[:noOfAnnotations] = 0
    end
    session[:noOfAnnotations] = session[:noOfAnnotations] + 1
    
    @outcomeAnnotation = recordAnnotation.save
    @outcomeUser = current_user.save

    redirect_to(annotate_work_path)
  end

  def admin
    @all_user = User.all
  end

end
