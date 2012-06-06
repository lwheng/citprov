require 'open-uri'
require 'nokogiri'

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
    puts data
    return "<h1>Hello World</h1>".html_safe
  end

  def self.cited(arg)
    # Fetch paper with id, cited
    cited = arg.split("==>")[1]
    
    file = open("http://wing.comp.nus.edu.sg/~antho/#{cited[0]}/#{cited[0,3]}/#{cited}-pdfbox.txt","r")
    data = ""
    id = 1
    while (line = file.gets)
      data = "#{data}<div id=\"line#{id}\">#{line.gsub("\n","")}</div>#{"\n"}"
      id += 1
    end
    return data.html_safe
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

