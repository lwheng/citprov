class CitedCitees < ActiveRecord::Base
	attr_accessible :cited, :citees
	def self.loaddata()
		file = File.open("#{Rails.root}/app/assets/data/cited-citees.txt", "r")
		while (line = file.gets)
		  puts "#{line}"
		end
	end
end
