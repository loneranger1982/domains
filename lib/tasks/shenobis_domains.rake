namespace :shenobis_domains do
  desc "TODO"
  task import_json: :environment do
  
   HardWorker.perform_async()
   
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
     domains=Domain.where(scraped: nil).count
    i=0
    while i < domains
      ParsedomainsWorker.perform_async(1000,i)
      i=i+1000
    end
    
  end
  
  task scrape_true: :environment do
     domains=Domain.where(haswebsite: true).count
    i=0
    while i < domains
      ParsedomainsWorker.perform_async(domains.id)
      i=i+1
    end
  end
end
