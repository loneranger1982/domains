class AddTrafficToDomains < ActiveRecord::Migration
  def change
    add_column :domains, :traffic, :integer
  end
end
