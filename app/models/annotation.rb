class Annotation < ActiveRecord::Base
    attr_accessible :cite_key, :user
    serialize :user, Hash

    validates :cite_key, presence: true
    validates :user, presence: true

    def self.parse(user, annotation)
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

    def self.display()
      # Displays records
      self.all.each do |record|
        puts "#{record.cite_key}"
        record.user.keys.each do |key|
          puts "\t#{key}\t\t#{record.user[key][:cite_class]},#{record.user[key][:cite_type]}"
        end
      end
      print
    end
end
# == Schema Information
#
# Table name: annotations
#
#  id         :integer         not null, primary key
#  cite_key   :string(255)
#  user       :text
#  created_at :datetime
#  updated_at :datetime
#

