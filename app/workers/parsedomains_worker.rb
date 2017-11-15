class ParsedomainsWorker
  include Sidekiq::Worker

  include Parsedomains

  
  def perform(id)
      domains=Domain.find(id)
      scrape_domains(domains)
  end
  #end filter domain report

end
