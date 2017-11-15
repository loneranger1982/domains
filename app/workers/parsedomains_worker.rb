class ParsedomainsWorker
  include Sidekiq::Worker
  include Sidekiq::Status::Worker
  include Parsedomains

  
  def perform(id)
   

    i=0
    
      domains=Domain.find(id)
   
    
    
    total domains.count
    filters=Filter.all
    domains.each do |d|
      i=i+1
      at i,"nearly There"
      loaddomain(d)
      
      matchfilter(false,filters)
      
    end
    savedomains
  end
  #end filter domain report

end
