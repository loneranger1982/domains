namespace :shenobis_domains do
  desc "TODO"
  task import_json: :environment do
    require 'net/ftp'
    require 'zip'
    
    
    #ftp = Net::FTP.new
    #ftp.connect("ftp.godaddy.com",21)
    #ftp.login("auctions","")
    #ftp.passive=true
    #ftp.getbinaryfile('expiring_service_auctions.csv.zip',"godaddy.zip")
    #Zip::File.open("godaddy.zip") do |zipfile|
      
      #zipfile.each do |f|
        
       # zipfile.extract(f,Dir.pwd+"/" + f.name){true}
        
      #end
      
    #end
    location=Dir.pwd + "/split_files/*.csv"
    
    Dir.glob("split-files/*.csv").select do |item|
      
      HardWorker.perform_async(item)
    end

  end
  
  task delete_expired: :environment do
    Domain.where("auctionendtime < ?",Time.now.to_i).delete_all
    
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
        domains.domainname=csv[0]
        domains.numberOfBids=csv[1]
        domains.auctionendtime=Time.strptime(csv[2],"%m/%d/%Y")
        domains.source="SnapNames"
        domains.save
        ParsedomainsWorker.perform_async(domains.id)
      end
    end
  end

  task scrape_domains: :environment do
     domains=Domain.where(scraped: nil)
    
    domains.each do |d|
      ParsedomainsWorker.perform_async(d.id)
      
    end
    
  end
  
  task scrape_true: :environment do
     domains=Domain.where(haswebsite: true)
    
    domains.each do |d|
      ParsedomainsWorker.perform_async(d.id)
      
    end
  end
end
