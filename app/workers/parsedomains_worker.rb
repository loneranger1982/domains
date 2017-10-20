class ParsedomainsWorker
  include Sidekiq::Worker
  include Sidekiq::Status::Worker
  include Parsedomains

  def perform(*args)
    i=0
    domains=Domain.all
    total domains.count
    domains.each do |d|
      i=i+1
      at i,"nearly There"
      loaddomain(d)
      matchfilter
      
    end
    
  end
end
