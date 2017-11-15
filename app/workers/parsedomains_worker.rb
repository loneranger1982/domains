class ParsedomainsWorker
  include Sidekiq::Worker

  include Parsedomains
  sidekiq_options queue: 'parsedomains'
  
  def perform(id)
    begin
      domains=Domain.find(id)
      scrape_domains(domains)
      rescue ActiveRecord::RecordNotFound
        return
    end
  end
  #end filter domain report

end
