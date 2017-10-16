class DomainController < ApplicationController
  
  def index
    respond_to do |format|
      format.html
      format.json {render json: DomainDatatable.new(view_context)}
    #@domains=Domain.paginate(:page =>params[:page])
    end
  end
  
  def datatable
    respond_to do |format|
      format.html
      format.json {render :json=> DomainDatatable.new(view_context)}
    end
    
  end
end