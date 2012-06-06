require 'open-uri'

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
  
  def self.cited(cited)
    # Fetch paper with id, cited
    file = open("http://wing.comp.nus.edu.sg/~antho/#{cited[0]}/#{cited[0,3]}/#{cited}-pdfbox.txt","r")
    data = file.read
    # puts data
    return data.gsub("\n", "<br>")
  end
  
  def self.citing(citing)
    return "<h1>Hello World</h1>".html_safe
  end
  
  def self.get_citing_sent(cited, citing)
    citings = Citees.find_by_cited(cited).citing
    puts citings
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

