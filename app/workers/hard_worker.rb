class HardWorker
  include Sidekiq::Worker
  include Sidekiq::Status::Worker
  sidekiq_options queue: 'download'

  def perform(file)
    require 'csv'
    total 5000
    message =0
    domains=[]
    i=0
    
    #Dir.glob(Dir.pwd +"/converted_files/*.csv") do |item|
   
      CSV.foreach(file,headers: true) do |row|
          timeauction=Time.strptime(row[3].to_s,"%m/%d/%Y %I:%M %p (%Z)").to_i
        if timeauction < Time.now.to_i
          next
        end
        
        
        
        d=Domain.new
        d.domainname=row[0]
        #d.link=item['link']
        #d.auctionType=hash['Auction Type']
        d.auctionendtime=Time.strptime(row[3].to_s,"%m/%d/%Y %I:%M %p (%Z)").to_i
        d.price=row[4].to_s
        d.numberOfBids=row[5].to_s
        d.domainAge=row[6].to_i
        d.valuation=row[8].to_s
        d.traffic=row[7].to_i
        
        d.source="GoDaddy Auctions"
        
        domains << d
        i=i+1
        at i
        if i % 100 ==0
          Domain.import domains, on_duplicate_key_ignore: true
          domains=[]
        end

      end
      
    #end




   
  end

  
end
