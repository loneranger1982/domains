module Parsedomains
  @@html=""
  @@pp=""
  
  @@domain=""
  @@t=Array.new
  @@f=Array.new
  
  def loaddomain (domain)
    
    @@domain=domain
    begin
        @@html = HTTParty.get("http://www." + domain.domainname,follow_redirects: true)
        #puts page
      rescue Net::OpenTimeout
        updatedomain(false)
      rescue SocketError
        updatedomain(false)
      rescue HTTParty::RedirectionTooDeep
        updatedomain(false)
    end
    
    @scraped=@@html
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
    savedomains
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