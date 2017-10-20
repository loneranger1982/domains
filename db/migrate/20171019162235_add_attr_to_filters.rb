class AddAttrToFilters < ActiveRecord::Migration
  def change
    add_column :filters, :attr, :string
  end
end
