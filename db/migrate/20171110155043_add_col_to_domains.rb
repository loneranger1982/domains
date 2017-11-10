class AddColToDomains < ActiveRecord::Migration
  def change
    add_column :domains,:filter,:string
  end
end
