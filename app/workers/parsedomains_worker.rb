class ParsedomainsWorker
  include Sidekiq::Worker
  include Sidekiq::Status::Worker
  include Parsedomains

  def perform(limit=100,offset=0)
    i=0
    domains=Domain.limit(limit).offset(offset)
    total domains.count
    domains.each do |d|
      i=i+1
      at i,"nearly There"
      loaddomain(d)
      matchfilter
      
    end
    
  end
end
