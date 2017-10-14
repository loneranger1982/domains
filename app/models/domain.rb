class Domain < ActiveRecord::Base
  
  self.per_page=10
  
  validates :domainName, presence:true,uniqueness:true
end