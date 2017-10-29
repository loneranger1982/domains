class ParsedomainsWorker

  include Parsedomains

  sidekiq_options :retry => false
  
  def perform(limit=100,offset=0,haswebsite = false)
   

    i=0
    if haswebsite
      domains=Domain.limit(limit).offset(offset).where(haswebsite: true)
    else
      domains=Domain.limit(limit).offset(offset).where(haswebsite: nil,scraped: nil).order("id ASC")
      
    end
    
    
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
