module Parsedomains
  @@html=""
  @@pp=""
  
  @@domain=""
  @@t=Array.new
  @@f=Array.new
  
  def loaddomain (domain)
    max_retries=2
    times_retried=0
    require 'curb'
    require 'benchmark'
    Benchmark.bm do |bm|
    @@domain=domain
    
    begin
        easy= Curl::Easy.new
        easy.follow_location=true
        easy.max_redirects=3
        easy.url="http://www." + domain.domainname
        easy.useragent="Ruby"
        res=easy.perform
        @@html =easy.body_str
        ##@@html = HTTParty.get("http://www." + domain.domainname,follow_redirects: true)
        #puts page
      rescue Curl::Err::RecvError
        updatedomain(false)
      rescue Net::OpenTimeout
        updatedomain(false)
      rescue Curl::Err::TooManyRedirectsError
        updatedomain(false)
      rescue Curl::Err::HostResolutionError
        updatedomain(false)
      rescue Net::ReadTimeout => error
        if times_retried < max_retries
          times_retried += 1
          puts "Failed to <do the thing>, retry #{times_retried}/#{max_retries}"
          retry
        else
          updatedomain(false)
          puts "Exiting script. <explanation of why this is unlikely to recover>"
          exit(1)
      end
    end
    bm.reportdo
    @scraped=@@html
  end
  end
  
  def loadIntoNoko 
    @@pp=Nokogiri(@@html)
  end

  
  def matchfilter(show=false,filters)
    
    if @@html.length < 10 
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
          updatedomain(false)
          matched="fa-check"
          fil[f.id]=matched
          fil
          return fil
        end
        
      end
      
      
      if findHTML =~ Regexp.new(f.regex)
        
        #f.matched="fa-check"
        updatedomain(false)
        matched="fa-check"
        fil[f.id]=matched
          fil
        return fil
      else
        #f.matched="fa-ban"
        updatedomain(true)
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
    Domain.where(:id =>@@t).update_all(:haswebsite => true)
    Domain.where(:id =>@@f).update_all(:haswebsite => false)
  end
  
  
end