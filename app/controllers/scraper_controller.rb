class ScraperController < ApplicationController
  
  def loadDomain
        
    
  #end loadHTML
  end
  #end class
  
  def scrapedomain
    @h=scraper_params
    
    @domainName = @h[:domainName]
   
    @scrapedDomain = HTTParty.get("http://www." + @h[:domainName])
  #end scrape domain  
  end
  
  private
  
  def scraper_params
    params.permit(:domainName)
  #end scraper Params
  end
end