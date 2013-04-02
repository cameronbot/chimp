class Publication < ActiveRecord::Base
  attr_accessible :domain, :formatted_name
  has_many :article
end
