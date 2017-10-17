class DomainController < ApplicationController
  
  def index
    respond_to do |format|
      format.html
      format.json {render json: DomainDatatable.new(view_context)}
    #@domains=Domain.paginate(:page =>params[:page])
    end
  end
  
  def show
    @domain =Domain.find(params[:id])
    @scraped=HTTParty.get("http://www." + @domain.domainName,follow_redirects:true)
    pp=Nokogiri(@scraped)
    @fil=Hash.new
    @filter=Filter.all.each do |f|
      
      if pp.css(f.selector).text =~ Regexp.new(f.regex)
        #domain.hasWebsite=false
        f.matched="fa-check"
      else
        f.matched="fa-ban"
        
        #domain.hasWebsite=true
      end
      @fil[f.id]=f.matched
      
    end
  end
  
  def datatable
    respond_to do |format|
      format.html
      format.json {render :json=> DomainDatatable.new(view_context)}
    end
    
  end
end