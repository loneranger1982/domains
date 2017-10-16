class DomainDatatable 
    delegate :params, :link_to, :number_to_currency, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      draw: params[:sEcho].to_i,
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
        link_to(product.domainName, product),
        product.price,
        product.numberOfBids,
        product.valuation,
        product.traffic,
        product.isAdult,
        product.auctionEndTime,
        product.hasWebsite,
        
      ]
    end
  end

  def products
    @products ||= fetch_products
  end

  def fetch_products
    products = Domain.order("#{sort_column} #{sort_direction}")
    products = products.page(page).per_page(per_page)
    if params["search"]["value"].present?
      
      products = products.where("domainName like :search", search: "%#{params['search']['value']}%")
    end
    if params["columns"]["8"]["search"]["value"].length > 0
      search = params["columns"]["8"]["search"]["value"]
      products = products.where(["domains.hasWebsite = ?", search])
    end
    products
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[id domainName price numberOfBids valuation traffic isAdult auctionEndTime hasWebsite]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
  
  
  
end
