class DomainDatatable 
    delegate :params, :link_to, :number_to_currency, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      draw: params[:draw].to_i,
      recordsTotal: Domain.count,
      recordsFiltered: products.total_entries,
      data: data
    }
  end

private

  def data
    products.map do |product|
      [
        product.id,
        link_to(product.domainname, product),
        product.price,
        product.numberOfBids,
        product.valuation,
        product.traffic,
        product.isAdult,
        Time.at(product.auctionendtime).to_datetime,
        product.hasWebsite,
        product.source
        
      ]
    end
  end

  def products
    @products ||= fetch_products
  end

  def fetch_products
    products = Domain.order("id ASC")
    products = products.page(page).per_page(per_page)
    if params["search"]["value"].present?
      svalue= params['search']['value']
      products = products.where("domainname like :search", search: "%#{params['search']['value']}%")
    end
    if params["columns"]["8"]["search"]["value"].length > 0
      search = params["columns"]["8"]["search"]["value"]
      products = products.where(hasWebsite: search)
    end
    if params["columns"]["9"]["search"]["value"].length > 0
      search = params["columns"]["9"]["search"]["value"]
      products = products.where(source: search)
    end
    products
  end

  def page
    params[:start].to_i/per_page + 1
  end

  def per_page
    params[:length].to_i > 0 ? params[:length].to_i : 10
  end

  def sort_column
    columns = %w[id domainName price numberOfBids valuation traffic isAdult auctionEndTime hasWebsite source]
    
    
  end

  def sort_direction
    params["order"]["0"]["dir"] == "desc" ? "desc" : "asc"
  end
  
  
  
end
