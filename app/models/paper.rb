# == Schema Information
#
# Table name: papers
#
#  id           :integer         not null, primary key
#  name         :string(255)
#  downloadlink :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#

class Paper < ActiveRecord::Base
end
