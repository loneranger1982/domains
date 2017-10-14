class CreateFilters < ActiveRecord::Migration
  def change
    create_table :filters do |t|
      t.string :name
      t.string :selector
      t.string :regex

      t.timestamps null: false
    end
  end
end
