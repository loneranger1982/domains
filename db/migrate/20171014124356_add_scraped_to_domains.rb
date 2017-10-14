class AddScrapedToDomains < ActiveRecord::Migration
  def change
    add_column :domains, :scraped, :boolean
    add_column :domains, :hasWebsite, :boolean
    add_column :domains, :isWordpress, :boolean
  end
end
