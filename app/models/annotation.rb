# == Schema Information
#
# Table name: annotations
#
#  id         :integer         not null, primary key
#  matric     :string(255)
#  content    :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Annotation < ActiveRecord::Base
  attr_accessible :matric, :content
end
