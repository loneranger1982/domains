class ScraperController < ApplicationController
  
  def loadDomain
        
    
  #end loadHTML
  end
  #end class
  
  def scrapedomain
    @h=scraper_params
    
    @domainName = @h[:domainName]
   require 'net/http'
   require 'uri'

   uri = URI.parse("http://www." + @h[:domainName])
   response =NET::HTTP.get_response(uri)
    @scrapedDomain = response
  #end scrape domain  
  end
  
  private
  
  def scraper_params
    params.permit(:domainName)
  #end scraper Params
  end
end