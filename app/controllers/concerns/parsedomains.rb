module Parsedomains
  @@html=""
  @@pp=""
  
  @@domain=""
  
  def loaddomain (domain)
    @@domain=domain
    begin
        @@html = HTTParty.get("http://www." + domain.domainName,follow_redirects: true)
        #puts page
      rescue Net::OpenTimeout
        domain.hasWebsite=false
        domain.save
      rescue SocketError
        domain.hasWebsite=false
        domain.save
      rescue HTTParty::RedirectionTooDeep
        domain.hasWebsite=false
        domain.save
    end
    
    @scraped=@@html
  end
  
  def loadIntoNoko 
    @@pp=Nokogiri(@@html)
  end

  
  def matchfilter(show=false)
    
    if @@html.length < 10 
        updatedomain(false)
    end
    loadIntoNoko
    filters=Filter.all
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
          return matched
        end
        
      end
      
      
      if findHTML =~ Regexp.new(f.regex)
        
        #f.matched="fa-check"
        updatedomain(false)
        matched="fa-check"
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
    @@domain.hasWebsite=result
    @@domain.save
  end
  
  
end