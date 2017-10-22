class FixColumnNames < ActiveRecord::Migration
  def change
    rename_column :domains, :domainName, :domainname
    rename_column :domains, :hasWebsite, :haswebsite
    rename_column :domains, :isWordpress, :iswordpress
  end
end
