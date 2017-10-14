class AddSourceToDomains < ActiveRecord::Migration
  def change
    add_column :domains, :source, :string
  end
end
