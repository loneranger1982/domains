module Parsedomains
  require 'curb'
  @@html=""
  @@pp=""
  
  @@domain=""
  @@t=Array.new
  @@f=Array.new
  
  def loaddomain (domain)
    max_retries=2
    times_retried=0
    

    @@domain=domain
    
    begin
        easy= Curl::Easy.new
        easy.follow_location=true
        easy.max_redirects=3
        easy.url="http://www." + domain.domainname
        easy.useragent="Ruby"
        easy.timeout=30
        res=easy.perform
        @@html =easy.body_str
        ##@@html = HTTParty.get("http://www." + domain.domainname,follow_redirects: true)
        #puts page
      rescue Curl::Err::RecvError
        savedomainwithFilter("recieve Error",0,@@domain.id)
        return
      rescue Net::OpenTimeout
        updatedomain(false)
        return
      rescue Curl::Err::TooManyRedirectsError
        savedomainwithFilter("Too Many Redirects",0,@@domain.id)
        return
      rescue Curl::Err::HostResolutionError
        savedomainwithFilter("Host Resolve Error",0,@@domain.id)
        return
      rescue Curl::Err::TimeoutError
        savedomainwithFilter("Timeout Error",0,@@domain.id)
        return
      rescue Curl::Err::SSLPeerCertificateError
        savedomainwithFilter("SSL Peer Error",0,@@domain.id)
        return
      rescue Curl::Err::ConnectionFailedError
        savedomainwithFilter("Connection Error",0,@@domain.id)
        return
        
      rescue Net::ReadTimeout => error
        if times_retried < max_retries
          times_retried += 1
          puts "Failed to <do the thing>, retry #{times_retried}/#{max_retries}"
          retry
        else
          savedomainwithFilter("Read Timeout Error",0,@@domain.id)
          puts "Exiting script. <explanation of why this is unlikely to recover>"
          return
      end
    end
    
    @scraped=@@html

  end
  
  def loadIntoNoko 
    @@pp=Nokogiri(@@html)
  end

  
  def matchfilter(show=false,filters)
    
    if @@html.length < 30 
        updatedomain(false)
    end
    loadIntoNoko
    
    fil=Hash.new
    filters.each do |f|
      
      case f.attr
      
      when "src"
        if !@@pp.css(f.selector)[0].nil?
          findHTML=@@pp.css(f.selector)[0]["src"]
          
        end
        
      when "text"
        findHTML=@@pp.css(f.selector).text
      
      when "htmllength"
        if @@html.length < f.regex.to_i
          savedomainwithFilter(f.name,0,@@domain.id)
          matched="fa-check"
          fil[f.id]=matched
          fil
          return
        end
        
      end
      
      
      if findHTML =~ Regexp.new(f.regex)
        
        #f.matched="fa-check"
        savedomainwithFilter(f.name,0,@@domain.id)
        matched="fa-check"
        fil[f.id]=matched
          fil
        return fil
      else
        #f.matched="fa-ban"
        savedomainwithFilter("NOT MATCHED",1,@@domain.id)
        matched="fa-ban"
        #true
      end
      if show==true
        fil[f.id]=matched
      end
    end
    
    fil
  end
  
  def updatedomain(result)
    if result==true
      @@t<<@@domain.id
    else
      @@f<<@@domain.id
    end
    
   # @@domain.haswebsite=result
    #@@domain.scraped=true
    #@@domain.save
  end
  
  def savedomains
    ActiveRecord::Base.connection_pool.with_connection do |c|
      
      Domain.where(:id =>@@t).update_all(:haswebsite => 1)
      #Domain.where(:id =>@@f).update_all(:haswebsite => 0)
    end
  end
  
  def savedomainwithFilter(filtername,result,id)
    ActiveRecord::Base.connection_pool.with_connection do |c|
      
      #Domain.where(:id => id).update_all(:haswebsite => 0,:filter => filtername)
      @@domain.update(:haswebsite => result,:filter => filtername)
    end
    
  end
  
  
end