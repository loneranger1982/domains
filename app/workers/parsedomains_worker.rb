class ParsedomainsWorker
  include Sidekiq::Worker
  include Sidekiq::Status::Worker
  include Parsedomains

  
  def perform(id)
   

    i=0
    
      domains=Domain.find(id)
   
    
    
    
    filters=Filter.all
   
      loaddomain(domains)
      
      matchfilter(false,filters)
      
    
    #savedomains
  end
  #end filter domain report

end
