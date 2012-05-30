# == Schema Information
#
# Table name: annotations
#
#  id         :integer         not null, primary key
#  user       :string(255)
#  citation   :text
#  created_at :datetime
#  updated_at :datetime
#

class Annotation < ActiveRecord::Base
  attr_accessible :user, :citation
  serialize :citation, Hash
  
  validates :user, presence: true
  validates :citation, presence: true
  
  def self.parse(args)
    # Parses annotation and returns a hash
    citations = args.split("\n")
    h = {}
    
    citations.each do |citation|
      info = citation.split(",")
      cite_key = info.first
      cite_class = info.second
      cite_type = info.last.strip
      
      h[cite_key] = { :cite_class => cite_class, :cite_type => cite_type }
    end
    h
  end
  
  def self.merge(old_citation, new_citation)
    # Merges old citation and new citation
    puts "Hello"
  end
end
