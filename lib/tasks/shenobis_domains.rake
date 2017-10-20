namespace :shenobis_domains do
  desc "TODO"
  task import_json: :environment do
  
   HardWorker.perform_async()
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
