class AddIndexToDomains < ActiveRecord::Migration
  def change
    add_index :domains, :domainname, unique: true
  end
end
