class Report < ActiveRecord::Base
  attr_accessible :article_ids
  has_many :article
end
