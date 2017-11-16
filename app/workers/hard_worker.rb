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
    totalsize=File.size(Dir.pwd + "/expiring_service_auctions.xml")
    total 450000
    parser = Saxerator.parser(File.new(Dir.pwd + "/expiring_service_auctions.xml"))
    Domain.bulk_insert(:domainname, :link, :auctionendtime, :numberOfBids, :domainAge, :traffic,:source,:html,ignore: true) do |worker|
      worker.set_size=10
      parser.for_tag(:item).each do |item|
      
    
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
        endtime=Time.strptime(hash['Auction End Time'],"%m/%d/%Y %I:%M %p (%Z)").to_i
        worker.add domainname: item['title'], link: item['link'], auctionendtime: endtime, domainAge: hash['domainAge'].to_i, traffic: hash['Traffic'].to_i, source:"GoDaddy Auctions",html:html
      #domains=Domain.new
      #domains.domainname=item['title']
      #domains.link=item['link']
      #domains.auctionType=hash['Auction Type']
      #domains.auctionendtime=Time.strptime(hash['Auction End Time'],"%m/%d/%Y %I:%M %p (%Z)").to_i
      #domains.price=hash['Price']
      #domains.numberOfBids=hash['Number of Bids']
      #domains.domainAge=hash['Domain Age'].to_i
      #domains.valuation=hash['Valuation']
      #domains.traffic=hash['Traffic'].to_i
      #domains.isAdult=hash['IsAdult']=='true'? true: false
      #domains.source="GoDaddy Auctions"
     
      #domains.save
      #ParsedomainsWorker.perform_async(domains.id)
        i=i+1
        at  i
      
      
    
      end

    end
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
        
        return
      rescue Net::OpenTimeout
        
        return
      rescue Curl::Err::TooManyRedirectsError
        
        return
      rescue Curl::Err::HostResolutionError
       
        return
      rescue Curl::Err::TimeoutError
        
        return
      rescue Curl::Err::SSLPeerCertificateError
        
        return
      rescue Curl::Err::ConnectionFailedError
        
        return
        
      rescue Net::ReadTimeout => error
        if times_retried < max_retries
          times_retried += 1
          
          retry
        else
          
          return
        end
      end

    return html
  end
end
