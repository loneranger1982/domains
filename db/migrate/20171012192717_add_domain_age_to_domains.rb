class AddDomainAgeToDomains < ActiveRecord::Migration
  def change
    add_column :domains, :domainAge, :integer
  end
end
