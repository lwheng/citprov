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