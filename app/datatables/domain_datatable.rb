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
        link_to(product.id,product),
        link_to(product.domainname, "http://www." + product.domainname, :target => "_blank"),
        product.price,
        product.numberOfBids,
        product.valuation,
        product.traffic,
        product.isAdult,
        Time.at(product.auctionendtime).to_datetime,
        product.haswebsite,
        
        product.source,
        product.filter
        
      ]
    end
  end

  def products
    @products ||= fetch_products
  end

  def fetch_products
    #products = Domain.order("id ASC")
    products = Domain.order("#{sort_column} #{sort_direction}")
    products = products.page(page).per_page(per_page)
    if params["search"]["value"].present?
      svalue= params['search']['value']
      products = products.where("domainname like :search", search: "%" + svalue.upcase + "%")
    end
    if params["columns"]["8"]["search"]["value"].length > 0
      search = params["columns"]["8"]["search"]["value"]
      products = products.where(haswebsite: search)
    end
    if params["columns"]["1"]["search"]["value"].length > 0
      search = params["columns"]["1"]["search"]["value"]
      products = products.where("domainname like :search",search: "%" + search)
    end
    if params["columns"]["7"]["search"]["value"].length > 0
      search = params["columns"]["7"]["search"]["value"]
      case search
        when "today"
          s=Time.now
          e=Time.now + 1.days
        when "tomorrow"
          s=Time.now + 1.days
          e=Time.now + 2.days
        when "2days"
          s=Time.now + 2.days
          e=Time.now + 3.days
        when "3days"
          s=Time.now + 3.days
          e=Time.now + 4.days
        when "4days"
          s=Time.now + 4.days
          e=Time.now + 5.days
        when "5days"
          s=Time.now + 5.days
          e=Time.now + 6.days
        end
      products = products.where("auctionendtime > :start and auctionendtime < :endtime",start: s.to_i, endtime: e.to_i)
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
    columns[params[:iSortCol_0].to_i]
    
  end

  def sort_direction
    params["order"]["0"]["dir"] == "desc" ? "desc" : "asc"
  end
  
  
  
end
