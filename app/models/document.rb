# == Schema Information
#
# Table name: documents
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  data       :json
#  created_at :datetime
#  updated_at :datetime
#

class Document < ActiveRecord::Base
end
