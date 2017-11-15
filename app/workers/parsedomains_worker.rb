class ParsedomainsWorker
  include Sidekiq::Worker

  include Parsedomains
  sidekiq_options queue: 'parsedomains'
  
  def perform(id)
      domains=Domain.find(id)
      if domains.length <= 0
        return
      else
        scrape_domains(domains)
      end
  end
  #end filter domain report

end
