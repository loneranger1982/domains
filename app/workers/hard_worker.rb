class HardWorker
  include Sidekiq::Worker

  def perform(*args)
    require 'net/ftp'
    require 'zip'
    ftp = Net::FTP.new
    ftp.connect("ftp.godaddy.com",21)
    ftp.login("auctions","")
    ftp.passive=true
    ftp.getbinaryfile('expiring_service_auctions.xml.zip',"godaddy.zip")
    Zip::File.open("godaddy.zip") do |zipfile|
      
      zipfile.each do |f|
        
        zipfile.extract(f,Dir.pwd+"/" + f.name)
        
      end
      
    end
    parser = Saxerator.parser(File.new(Dir.pwd + "/expiring_service_auctions.xml"))
    parser.for_tag(:item).each do |item|
      
    
      s=item['description']
      details=s.split(',')
      hash={}
      details.each do |e|
       
        kv=e.split(':',2)
      
        hash[kv[0].to_s.strip]=kv[1].to_s.strip
       
       end
     
      puts hash
      domains=Domain.new
      domains.domainName=item['title']
      domains.link=item['link']
      domains.auctionType=hash['Auction Type']
      domains.auctionEndTime=Time.strptime(hash['Auction End Time'],"%m/%d/%Y %I:%M %p (%Z)")
      domains.price=hash['Price']
      domains.numberOfBids=hash['Number of Bids']
      domains.domainAge=hash['Domain Age'].to_i
      domains.valuation=hash['Valuation']
      domains.traffic=hash['Traffic'].to_i
      domains.isAdult=hash['IsAdult']=='true'? true: false
      domains.source="GoDaddy Auctions"
     
      domains.save
     
    
    end
  end
end
