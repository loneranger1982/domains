class DomainController < ApplicationController
  
  def index
    @domains=Domain.paginate(:page =>params[:page])
  end
end