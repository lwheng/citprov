class User < ActiveRecord::Base
  attr_accessible :username, :annotations, :old_annotation_count
  serialize :annotations, Hash
  
  class << self
    def authenticate_with_username(id, cookie_username)
      user = find_by_id(id)
      (user && user.username == cookie_username) ? user : nil
    end
    
    def get_annotate_count(username)
      user = find_by_username(username)
      if user.new_annotation_count
        return user.new_annotation_count
      else
        return 0
      end
    end
  end
end
# == Schema Information
#
# Table name: users
#
#  id                   :integer         not null, primary key
#  username             :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#  annotations          :text
#  old_annotation_count :integer
#  new_annotation_count :integer
#

