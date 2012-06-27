require 'open-uri'
require 'rexml/document'
require 'text'
include REXML
include Text

class Annotation < ActiveRecord::Base
    attr_accessible :cite_key, :annotations, :annotation_count, :context
    serialize :annotations, Hash

    validates :cite_key, presence: true
    # validates :user, presence: true # commented away to allow initialisation
    validates :annotation_count, presence: true
    
    class << self
      def loaddata()
        # This method should only be ran once
        # Loads all cite keys into model

        # Read cite keys from annotationsMaster.txt
        # And that add these keys into model
        file = File.open("#{Rails.root}/app/assets/data/annotationsMaster.txt", "r")
        while (line = file.gets)
          cite_key =  line.split(",")[0]

          # Check model whether cite_key exists. If not, then save to model accordingly
          # Set users_count to zero by default
          unless find_by_cite_key(cite_key)
            newRecord = new(:cite_key => cite_key)
            newRecord.users_count = 0
            newRecord.save
          end
        end
      end

      def parse(user, annotation)
        # Parses annotation and returns a hash
        citations = annotation.split("\n")
        h = {}

        citations.each do |citation|
          info = citation.split(",")
          cite_key = info.first
          cite_class = info.second
          cite_type = info.last.strip

          h[cite_key] = { user => { :cite_class => cite_class, :cite_type => cite_type } }
        end
        h
      end

      def annotation_count()
        # An administrative method used to sort out the no. of annotators for each record
        all.each do |record|
          record.annotation_count = record.annotations.keys.size
          record.save
        end
      end

      def get_first()
        # Not the conventional first record.
        # Gets the record that is nearest to getting 3 annotators
        # Returns the record
        if result = find_by_annotation_count(2)
          return result
        elsif result = find_by_annotation_count(1)
          return result
        elsif result = find_by_annotation_count(0)
          return result
        end
      end
      
      def get_first1(arg)
        if arg == 0
          return find_by_annotation_count(0)
        end
        result = find(:all, :conditions => ["annotation_count = ?", arg])
        return result
      end

      def get_citees(arg)
        # Gets all the citees that cites a cited paper
        # Exclude those that had been cited 3 times
        # Returns a list of cite_keys
        cited = arg.split("==>")[1]
        results = find(:all, :conditions => ["cite_key LIKE ? AND annotation_count <> ?", "\%==>#{cited}", "3"], :order =>
        "annotation_count DESC")
        # citees = []
        # results.each do |v|
        #   citees.concat([v.cite_key])
        # end
        # return citees
        return results
      end
      
      def citing(arg)
        info = arg.split("==>")
        citing = info[0]
        cited = info[1]

        titleCited = ""
        booktitleCited = ""
        # Get the title of the cited paper
        # Try bib file first because the file size smallest
        begin
          file = open("http://wing.comp.nus.edu.sg/~antho/#{cited[0]}/#{cited[0,3]}/#{cited}.bib","r")
          regexTitle = /(^title)\s*=\s*\{(.*)\}/
          regexBookTitle = /(^booktitle)\s*=\s*\{(.*)\}/
          while (line = file.gets)
            line = line.strip
            if match = regexTitle.match(line)
              titleCited = match[2]
            elsif match = regexBookTitle.match(line)
              booktitleCited = match[2]
            end
          end
        rescue => error
          # no bib file. try seersuite file
          begin
            file = open("http://wing.comp.nus.edu.sg/~antho/#{cited[0]}/#{cited[0,3]}/#{cited}-pdfbox-seersuite.txt","r")
            data = file.read
            root = (Document.new data).root
            content = root.elements
            if content["title"]
              titleCited = content["title"].text
            end
          rescue => error1
            # no seersuit file either. try -final.xml
            begin
              file = open("http://wing.comp.nus.edu.sg/~antho/#{cited[0]}/#{cited[0,3]}/#{cited}-final.xml","r")
              data = file.read
              root = (Document.new data).root
              title = root.elements["teiHeader"].elements["fileDesc"].elements["titleStmt"].elements["title"]
              titleCited = title.text
            rescue => error2
              puts "No title!"
            end
          end
        end

        # Get citations's context and title
        citationCiting = nil
        distance = 314159265358979323846
        display = ""
        begin
           file = open("http://wing.comp.nus.edu.sg/~antho/#{citing[0]}/#{citing[0,3]}/#{citing}-parscit.xml","r")
           data = file.read
           root = (Document.new data).root
           citationList = root.elements["algorithm"].elements["citationList"]
           citations = citationList.elements
           citations.each do |v|
             if title = v.elements["title"]
               check = Levenshtein.distance(titleCited, title.text)
               if check < distance
                 citationCiting = v
                 distance = check
               end
             end
           end
           contexts = citationCiting.elements["contexts"]
           contexts.elements.each do |v|
             context = v.text
             citStr = v.attributes["citStr"]
             context = context.gsub(citStr, "<b>#{citStr}</b>")
             display = "#{display}<div>.....#{context}.....</div><br>"
           end
           return display.html_safe
         rescue => error
           puts "Error!!!"
           puts error.backtrace.join("\n")
         end
      end
      
      def cited(arg)
        # Fetch paper with id, cited
        cited = arg.split("==>")[1]

        begin
          # Attempts to fetch *-parscit-section.xml
          file = open("http://wing.comp.nus.edu.sg/~antho/#{cited[0]}/#{cited[0,3]}/#{cited}-parscit-section.xml","r")
          data = file.read
          root = (Document.new data).root
          content = root.elements["algorithm"].elements["variant"]

          # content is <variant> in *-parscit-section.xml
          # Display content with better formatting
          display = ""
          content.elements.each do |tag|
            case tag.name

            when "address"
              address = tag.text
              address_lines = address.split("\n")
              address_lines.each do |v|
                if v.length > 0
                  display = "#{display}<div><i>#{v}</i></div>"
                end
              end
            when "affiliation"
              affiliation = tag.text
              affiliation_lines = affiliation.split("\n")
              affiliation_lines.each do |v|
                if v.length > 0
                  display = "#{display}<div><i>#{v}</i></div>"
                end
              end
            when "author"
              display = "#{display}<div><h4>#{tag.text}</h4></div>"
            when "bodyText"
              bodyText = tag.text
              bodyText_lines = bodyText.split("\n")
              bodyText_lines.each do |v|
                if v.length > 0
                  display = "#{display}<div>#{v}</div>"
                end
              end
            when "category"
              category = tag.text
              category_lines = category.split("\n")
              category_lines.each do |v|
                if v.length > 0
                  display = "#{display}<div>#{v}</div>"
                end
              end
            when "construct"
              construct = tag.text
              construct_lines = construct.split("\n")
              construct_lines.each do |v|
                if v.length > 0
                  display = "#{display}<div>#{v}</div>"
                end
              end
            when "copyright"
              copyright = tag.text
              copyright_lines = copyright.split("\n")
              copyright_lines.each do |v|
                if v.length > 0
                  display = "#{display}<div><i>#{v}</i></div>"
                end
              end
            when "email"
              display = "#{display}<div>#{tag.text}</div>"
            when "equation"
              equation = tag.text
              equation_lines = equation.split("\n")
              equation_lines.each do |v|
                if v.length > 0
                  display = "#{display}<div><i>#{v}</i></div>"
                end
              end
            when "figure"
              figure = tag.text
              figure_lines = figure.split("\n")
              figure_lines.each do |v|
                if v.length > 0
                  display = "#{display}<div><i>#{v}</i></div>"
                end
              end
            when "figureCaption"
              display = "#{display}<div><i><b>#{tag.text}</b></i></div>"
            when "footnote"
              footnote = tag.text
              footnote_lines = footnote.split("\n")
              footnote_lines.each do |v|
                if v.length > 0
                  display = "#{display}<div><i><span class='muted'>#{v}</span</i></div>"
                end
              end
            when "keyword"
              display = "#{display}<div><b>#{tag.text}</b></div>"
            when "listItem"
              listItem = tag.text
              listItem_lines = listItem.split("\n")
              listItem_lines.each do |v|
                if v.length > 0
                  display = "#{display}<div>#{v}</div>"
                end
              end
            when "note"
              display = "#{display}<div>#{tag.text}</div>"
            when "page"
              display = "#{display}<div><span class='muted'>#{tag.text}</span></div>"
            when "reference"
              reference = tag.text
              reference_lines = reference.split("\n")
              reference_lines.each do |v|
                if v.length > 0
                  display = "#{display}<div><i>#{v}</i></div>"
                end
              end
            when "sectionHeader"
              display = "#{display}<div><h4>#{tag.text}</h4></div>"
            when "subsectionHeader"
              display = "#{display}<div><h4>#{tag.text}</h4></div>"
            when "subsubsectionHeader"
              display = "#{display}<div><h4>#{tag.text}</h4></div>"
            when "table"
              table = tag.text
              table_lines = table.split("\n")
              table_lines.each do |v|
                if v.length > 0
                  display = "#{display}<div><i>#{v}</i></div>"
                end
              end
            when "tableCaption"
              display = "#{display}<div><i><b>#{tag.text}</b></i></div>"
            when "title"
              display = "#{display}<div><h3>#{tag.text}</h3></div>"
            end
          end
          return display.html_safe
        rescue => error
          # No xml format found. Revert to using txt format
          # Attempt to do some formatting using regex to match section headers
          file = open("http://wing.comp.nus.edu.sg/~antho/#{cited[0]}/#{cited[0,3]}/#{cited}-pdfbox.txt","r")
          display = ""
          title = true # assumes first line is the title
          while (line = file.gets)
            regexSection = /([0-9]) ([A-Z][a-z]+$)/
            regexAbstractAcknowledgeReference = /(^[A-Z][a-z]+$)/
            if match = regexSection.match(line)
              # matched a numbered section
              display = "#{display}<div><h4>#{line}</h4></div>"
            elsif match = regexAbstractAcknowledgeReference.match(line)
              # matched un-numbered section
              display = "#{display}<div><h4>#{line}</h4></div>"
            else
              if title
                display = "#{display}<div><h3>#{line}</h3></div>"
                title = nil
              else
                display = "#{display}<div>#{line}</div>"
              end
            end
          end
          return display.html_safe
        end
      end
      
      def cited_pdf_link(arg)
        cited = arg.split("==>")[1]
        return "http://www.aclweb.org/anthology/#{cited[0]}/#{cited[0,3]}/#{cited}.pdf"
      end

      def citing_pdf_link(arg)
        citing = arg.split("==>")[0]
        return "http://www.aclweb.org/anthology/#{citing[0]}/#{citing[0,3]}/#{citing}.pdf"
      end
      
      def context(arg)
        # arg is already the Annotation record
        if arg.context
          root = (Document.new arg.context).root
          return root.text
        else
          return "This is a demo, and should display the context from the citing paper"
        end
      end
    end
end
# == Schema Information
#
# Table name: annotations
#
#  id               :integer         not null, primary key
#  cite_key         :string(255)
#  annotations      :text
#  created_at       :datetime
#  updated_at       :datetime
#  annotation_count :integer
#  context          :text
#

