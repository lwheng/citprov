class Annotation < ActiveRecord::Base
    attr_accessible :cite_key, :user, :users_count
    serialize :user, Hash

    validates :cite_key, presence: true
    # validates :user, presence: true # commented away to allow initialisation
    validates :users_count, presence: true
    
    def self.loaddata()
      # This method should only be ran once
      # Loads all cite keys into model
      
      # Read cite keys from annotationsMaster.txt
      # And that add these keys into model
      file = File.open("#{Rails.root}/app/assets/data/annotationsMaster.txt", "r")
      while (line = file.gets)
        cite_key =  line.split(",")[0]
        
        # Check model whether cite_key exists. If not, then save to model accordingly
        # Set users_count to zero by default
        unless self.find_by_cite_key(cite_key)
          newRecord = self.new(:cite_key => cite_key)
          newRecord.users_count = 0
          newRecord.save
        end
      end
    end

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
    
    def self.users_count()
      # An administrative method used to sort out the no. of annotators for each record
      self.all.each do |record|
        record.users_count = record.user.keys.size
        record.save
      end
    end
    
    def self.get_first()
      # Not the conventional first record.
      # Gets the first record that is nearest to getting 3 annotators
      # Returns the cite_key
    
      result = self.find_by_users_count(2)
      if result.nil?
        result = self.find_by_users_count(1)
        if result.nil?
          result = self.find_by_users_count(0)
        end
      end
      return result.cite_key
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

