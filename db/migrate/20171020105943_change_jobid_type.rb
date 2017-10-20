class ChangeJobidType < ActiveRecord::Migration
  def change
    change_column :jobs, :jobid, :string
  end
end
