class HardWorker
  include Sidekiq::Worker
  include Sidekiq::Status::Worker

  def perform(*args)
    require 'net/ftp'
    require 'zip'
    i=0
    
    ftp = Net::FTP.new
    ftp.connect("ftp.godaddy.com",21)
    ftp.login("auctions","")
    ftp.passive=true
    ftp.getbinaryfile('expiring_service_auctions.xml.zip',"godaddy.zip")
    Zip::File.open("godaddy.zip") do |zipfile|
      
      zipfile.each do |f|
        
        zipfile.extract(f,Dir.pwd+"/" + f.name){true}
        
      end
      
    end
    
    total 450000
    message =0
    parser = Saxerator.parser(File.new(Dir.pwd + "/expiring_service_auctions.xml"))
    
    domains=[]
    parser.for_tag(:item).each do |item|
      
    timestart=Time.now.to_i
      s=item['description']
      details=s.split(',')
      hash={}
      details.each do |e|
        kv=e.split(':',2)
        hash[kv[0].to_s.strip]=kv[1].to_s.strip
      end
     
      if Time.strptime(hash['Auction End Time'],"%m/%d/%Y %I:%M %p (%Z)").to_i < Time.now.to_i
          
        next
      end

      html=loadhtml(item['title'])
        

        
      d=Domain.new
      d.domainname=item['title']
      d.link=item['link']
      d.auctionType=hash['Auction Type']
      d.auctionendtime=Time.strptime(hash['Auction End Time'],"%m/%d/%Y %I:%M %p (%Z)").to_i
      d.price=hash['Price']
      d.numberOfBids=hash['Number of Bids']
      d.domainAge=hash['Domain Age'].to_i
      d.valuation=hash['Valuation']
      d.traffic=hash['Traffic'].to_i
      d.isAdult=hash['IsAdult']=='true'? true: false
      d.source="GoDaddy Auctions"
      d.html=html
      domains << d
      #domains.save
      #ParsedomainsWorker.perform_async(domains.id)
        i=i+1
        at  i,message
      if i % 100 == 0
        Domain.import domains, on_duplicate_key_ignore: true
        domains=[]
      end
      timeend=Time.now.to_i
      message=((timeend-timestart) * 1000 * (450000-i))
    end
    Domain.import domains, on_duplicate_key_ignore: true
    domains=[]
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
