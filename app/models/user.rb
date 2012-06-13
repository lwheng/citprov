class User < ActiveRecord::Base
  attr_accessible :username
  
  class << self
    def authenticate_with_username(id, cookie_username)
      user = find_by_id(id)
      (user && user.username == cookie_username) ? user : nil
    end
  end
end
# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  username   :string(255)
#  created_at :datetime
#  updated_at :datetime
#

