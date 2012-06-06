class CitedCitees < ActiveRecord::Base
	attr_accessible :cited, :citees
	def self.loaddata()
    # This method should only be ran once
    # Clear all records first
    CitedCitees.delete_all
    
    # Now proceed to filling model
		file = File.open("#{Rails.root}/app/assets/data/cited-citees.txt", "r")
		while (line = file.gets)
		  info = line.gsub("\n","").split("=")
		  key = info[0]
      values = info[1]
      newRecord = CitedCitees.new
      newRecord.cited = key
      newRecord.citees = values
      newRecord.save
		end
	end
end
