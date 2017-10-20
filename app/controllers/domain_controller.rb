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
    @fil=matchfilter(true)

  end
  def parsedomains
    ParsedomainsWorker.perform_async()
    flash[:notice]="Parse Domains Added to Queue Successfully"
    redirect_to domain_index_path
    
  end
  def datatable
    respond_to do |format|
      format.html
      format.json {render :json=> DomainDatatable.new(view_context)}
    end
    
  end
end