class AddColumnHtmlToDomains < ActiveRecord::Migration
  def change
  	add_column :domains, :html, :text
  end
end
