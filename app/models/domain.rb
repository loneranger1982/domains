class Domain < ActiveRecord::Base
  
  self.per_page=10
  
  #validates :domainname, presence:true,uniqueness:true
end