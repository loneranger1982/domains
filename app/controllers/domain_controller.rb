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
    loaddomain(@domain)
    @filter=Filter.all
    
    @fil=matchfilter(true,@filter)
    savedomains
    

  end
  def parsedomains
    if(params['websites'])
      domains=Domain.where(scraped: true,haswebsite: true).count
      
    else
      domains=Domain.where(scraped: nil,haswebsite: nil).count
    end
    
    i=0
    puts "Domains=#{domains}"  
    while i < domains
      ParsedomainsWorker.perform_async(1000,i)
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
