class ParsedomainsWorker
  include Sidekiq::Worker
  include Sidekiq::Status::Worker
  include Parsedomains

  def perform(limit=100,offset=0,haswebsite = false)
    i=0
    if haswebsite
      domains=Domain.limit(limit).offset(offset).where(haswebsite: true)
    else
      domains=Domain.limit(limit).offset(offset).where(scraped: nil)
    end
    
    total domains.count
    domains.each do |d|
      i=i+1
      at i,"nearly There"
      loaddomain(d)
      matchfilter
      
    end
    
  end
end
