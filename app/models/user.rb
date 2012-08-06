require 'digest/md5'

class User < ActiveRecord::Base
  attr_accessible :username, :annotations, :old_annotation_count, :md5
  serialize :annotations, Hash
  serialize :md5, Array
  
  class << self
    def authenticate_with_username(id, cookie_username)
      user = find_by_id(id)
      (user && user.username == cookie_username) ? user : nil
    end
    
    def generate_md5(user)
      time = Time.now.getutc
      return Digest::MD5.hexdigest("#{user.username}#{time}")
    end

    def check_not_paid(md5)
      md5.each do |m|
        if !m[2]
          return true
        else
          return false
        end
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
#  md5                  :text
#

