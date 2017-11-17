class HardWorker
  include Sidekiq::Worker
  include Sidekiq::Status::Worker
  

  def perform(file)
    require 'csv'
    total 2500
    message =0
    domains=[]
    i=0
    
    #Dir.glob(Dir.pwd +"/converted_files/*.csv") do |item|
    puts file
      CSV.foreach(file,headers: true) do |row|
        if row[0]=nil
          next
        end
        puts row[0]
        html=loadhtml(row[0])
        d=Domain.new
        d.domainname=row[0]
        #d.link=item['link']
        #d.auctionType=hash['Auction Type']
        d.auctionendtime=Time.strptime(row[3],"%m/%d/%Y %I:%M %p (%Z)").to_i
        d.price=row[4]
        d.numberOfBids=row[5]
        d.domainAge=row[6].to_i
        d.valuation=row[8]
        d.traffic=row[7].to_i
        
        d.source="GoDaddy Auctions"
        d.html=html
        domains << d
        i=i+1
        at i
        if i % 10
          Domain.import domains, on_duplicate_key_ignore: true
      domains=[]
        end

      end
      
    #end




   
  end

  def loadhtml(url)
    max_retries=2
    times_retried=0

    
    begin
      easy= Curl::Easy.new
      easy.follow_location=true
      easy.max_redirects=3
      easy.url="http://www." + url
      easy.useragent="Ruby"
      easy.timeout=30
      res=easy.perform
      html =easy.body_str
        ##@@html = HTTParty.get("http://www." + domain.domainname,follow_redirects: true)
        #puts page
      rescue Curl::Err::RecvError
          html="Error"
        return
      rescue Net::OpenTimeout
        html="Error"
        return
      rescue Curl::Err::TooManyRedirectsError
        html="Error"
        return
      rescue Curl::Err::HostResolutionError
       html="Error"
        return
      rescue Curl::Err::TimeoutError
        html="Error"
        return
      rescue Curl::Err::SSLPeerCertificateError
        html="Error"
        return
      rescue Curl::Err::ConnectionFailedError
        html="Error"
        return
        
      rescue Net::ReadTimeout => error
        if times_retried < max_retries
          times_retried += 1
          html="Error"
          retry
        else
          html="Error"
          return
        end
      end

    return html
  end
end
