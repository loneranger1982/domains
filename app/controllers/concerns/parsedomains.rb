module Parsedomains
  require 'curb'

  def scrape_domains(domain)
    #pp=loaddomain(domain)
    #puts pp
    filters=Filter.all
    matchfilter(false,filters,domain)
    
  end
  
  def loaddomain (domain)
    max_retries=2
    times_retried=0

    
    begin
        easy= Curl::Easy.new
        easy.follow_location=true
        easy.max_redirects=3
        easy.url="http://www." + domain.domainname
        easy.useragent="Ruby"
        easy.timeout=30
        res=easy.perform
        html =easy.body_str
        ##@@html = HTTParty.get("http://www." + domain.domainname,follow_redirects: true)
        #puts page
      rescue Curl::Err::RecvError
        savedomainwithFilter("recieve Error",0,domain)
        return
      rescue Net::OpenTimeout
        savedomainwithFilter("OpenTimeout",0,domain)
        return
      rescue Curl::Err::TooManyRedirectsError
        savedomainwithFilter("Too Many Redirects",0,domain)
        return
      rescue Curl::Err::HostResolutionError
        savedomainwithFilter("Host Resolve Error",0,domain)
        return
      rescue Curl::Err::TimeoutError
        savedomainwithFilter("Timeout Error",0,domain)
        return
      rescue Curl::Err::SSLPeerCertificateError
        savedomainwithFilter("SSL Peer Error",0,domain)
        return
      rescue Curl::Err::ConnectionFailedError
        savedomainwithFilter("Connection Error",0,domain)
        return
        
      rescue Net::ReadTimeout => error
        if times_retried < max_retries
          times_retried += 1
          puts "Failed to <do the thing>, retry #{times_retried}/#{max_retries}"
          retry
        else
          savedomainwithFilter("Read Timeout Error",0,domain)
          puts "Exiting script. <explanation of why this is unlikely to recover>"
          return
      end
    end
    
    
    return html
  end
  

  
  def matchfilter(show=false,filters,domain)
    
  begin  
    require 'nokogiri'
    if domain.html==nil
      html=loaddomain(domain)
      if html==nil 
        savedomainwithFilter("Returned Blank",0,domain)
        return
      end
      pp=Nokogiri(html)
    else
      pp=Nokogiri(domain.html)
    end
    fil=Hash.new
    filters.each do |f|
      fil[f.id]="fa-ban"
      
      case f.attr
      
      when "src"
        
          findHTML=pp.css(f.selector).first["src"]
          
        
      when "metaurl"
          findhtml=pp.css('meta').first['content']
      when "text"
        findHTML=pp.css(f.selector).text
      
      when "htmllength"
        if pp.css('html').first.to_s.size < f.regex.to_i
          savedomainwithFilter(f.name,0,domain)
          matched="fa-check"
          fil[f.id]=matched
          fil
          return
        end
        
      end
      
      
      if findHTML =~ Regexp.new(f.regex)
        
        #f.matched="fa-check"
        savedomainwithFilter(f.name,0,domain)
        matched="fa-check"
        fil[f.id]=matched
          fil
        return fil
      else
        #f.matched="fa-ban"
        savedomainwithFilter("NOT MATCHED",1,domain)
        matched="fa-ban"
        #true
      end
      if show==true
        fil[f.id]=matched
      end
    end
  rescue NoMethodError =>e 

    return fil
  end  
    fil
  end
  

  
  def savedomainwithFilter(filtername,result,domains)
    ActiveRecord::Base.connection_pool.with_connection do |c|
      
      #Domain.where(:id => id).update_all(:haswebsite => 0,:filter => filtername)
      domains.update(:haswebsite => result,:filter => filtername,:scraped => true)
    end
    
  end
  
  
end