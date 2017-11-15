class DomainController < ApplicationController
  include Parsedomains
  
  def index
    respond_to do |format|
      format.html
      format.json {render json: DomainDatatable.new(view_context)}
    #@domains=Domain.paginate(:page =>params[:page])
    end
  end
  
  def show
    
    
    @domain =Domain.find(params[:id])
   
    
    @fil=scrape_domains(@domain)
    

  end
  def parsedomains
    if(params['websites'])
      domains=Domain.where(haswebsite: true).count
      haswebsite=true
    else
      domains=Domain.where(scraped: nil,haswebsite: nil).count
      haswebsite=false
    end
    
    i=0
    puts "Domains=#{domains}"  
    while i < domains
      ParsedomainsWorker.perform_async(1000,i,haswebsite)
      i=i+1000
    end
    
    flash[:notice]="Parse Domains Added to Queue Successfully"
    redirect_to root_path
    
  end
  
  
  
  def datatable
    respond_to do |format|
      format.html
      format.json {render :json=> DomainDatatable.new(view_context)}
    end
    
  end
end
