require 'open-uri'
require "rexml/document"
include REXML

class Citees < ActiveRecord::Base
  attr_accessible :cited, :citing
  
  def self.loaddata()
    # This method should only be ran once
    # First remove all records in table
    Citees.delete_all

    # Now we add all records
    file = File.open("#{Rails.root}/app/assets/data/cited-citees.txt", "r")
    while (line = file.gets)
      info = line.gsub("\n","").split("=")
      key = info[0]
      values = info[1]
      newRecord = Citees.new
      newRecord.cited = key
      newRecord.citing = values
      newRecord.save
    end
  end
  
  def self.citing(arg)
    info = arg.split("==>")
    citing = info[0]
    cited = info[1]
    
    file = open("http://wing.comp.nus.edu.sg/~antho/#{citing[0]}/#{citing[0,3]}/#{citing}-parscit.xml","r")
    data = file.read
    root = (Document.new data).root
    citationList = root.elements["algorithm"].elements["citationList"]
    citationList.elements.each do |v|
      if v.elements["contexts"]
        # Has context
        puts v.elements["contexts"].elements["context"]
      else
        # Has no context
        puts "No context"
      end
    end
    return "<h1>Hello World</h1>".html_safe
  end

  def self.cited(arg)
    # Fetch paper with id, cited
    cited = arg.split("==>")[1]
    
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
        display = "#{display}<h4>#{tag.text}</h4>"
      when "subsectionHeader"
        display = "#{display}<h4>#{tag.text}</h4>"
      when "subsubsectionHeader"
        display = "#{display}<h4>#{tag.text}</h4>"
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
  end
  
  def self.cited_pdf_link(arg)
    cited = arg.split("==>")[1]
    return "http://wing.comp.nus.edu.sg/~antho/#{cited[0]}/#{cited[0,3]}/#{cited}.pdf"
    
  end
end
# == Schema Information
#
# Table name: citees
#
#  id         :integer         not null, primary key
#  cited      :string(255)
#  citing     :text
#  created_at :datetime
#  updated_at :datetime
#

