class ParsedomainsWorker
  include Sidekiq::Worker
  include Parsedomains

  def perform(*args)
    domains=Domain.all
    domains.each do |d|
      loaddomain(d)
      matchfilter
      
    end
    
  end
end
