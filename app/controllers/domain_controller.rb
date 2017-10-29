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
    domains=Domain.where(scraped: nil,haswebsite: nil).count
    i=0
    while i < domains
      Resque.enqueue(parsedomains_worker,100,i)
      #ParsedomainsWorker.perform_async(100,i)
      i=i+100
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