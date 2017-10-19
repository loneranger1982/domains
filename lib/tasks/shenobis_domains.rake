namespace :shenobis_domains do
  desc "TODO"
  task import_json: :environment do
  begin
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
  rescue =>e
    puts e
  end
  end

  task import_snapnames: :environment do
    begin
require 'open-uri'
download = open('https://www.snapnames.com/file_dl.sn?file=snpalist.zip')
IO.copy_stream(download, 'snapnames.zip')
    require 'zip'
    Zip::File.open("snapnames.zip") do |zipfile|
      
      zipfile.each do |f|
        
        zipfile.extract(f,Dir.pwd+"/" + f.name){true}
        
      end
      
    end
      file=File.new(Dir.pwd + "/snpalist.txt").drop(3).join().squeeze(" ").gsub!(' ',"\t")
      header="domain\tbid\tend\t\r\n"
      file.prepend(header)
      #puts file.inspect
      TSV.parse(file)do |csv|
        domains=Domain.new
        domains.domainName=csv[0]
        domains.numberOfBids=csv[1]
        domains.auctionEndTime=Time.strptime(csv[2],"%m/%d/%Y")
        domains.source="SnapNames"
        domains.save
      end
    end
  end

  task scrape_domains: :environment do
    
    begin
    domains=Domain.where(scraped: nil).limit(100)
    #domains=Domain.all.limit(5)
    #puts domains.length
    domains.each do |domain|
      #puts domain.domainName
      begin
        page = HTTParty.get("http://www." + domain.domainName,follow_redirects: true)
        #puts page
      rescue Net::OpenTimeout
        puts "timeout"
      rescue SocketError
        puts "Socket Error"
      rescue HTTParty::RedirectionTooDeep
        puts "too Deep"
      end
    
      pp=Nokogiri::HTML(page)
      Filter.all.each do |f|
        #puts f.selector
      if pp.css(f.selector).text =~ Regexp.new(f.regex)
        domain.hasWebsite=false
        puts "Found #{f.selector}"
      else
        domain.hasWebsite=true
      end
    end
      domain.scraped=true
      domain.save
    end
    
    
    end
  end

end
