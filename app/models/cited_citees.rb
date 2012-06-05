require 'open-uri'
	
class CitedCitees < ActiveRecord::Base
	attr_accessible :cited, :citees
	def self.loaddata()
    # This method should only be ran once
		file = File.open("#{Rails.root}/app/assets/data/cited-citees.txt", "r")
		while (line = file.gets)
		  puts "#{line}"
		end
		
		file1 = open("http://wing.comp.nus.edu.sg/~antho/A/A00/A00-3008-merge.xml", "r")
		data = file1.read
		puts data
	end
end
