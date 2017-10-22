class ChangeAuctionenddateToInteger < ActiveRecord::Migration
  def change
    remove_column :domains, :auctionEndTime, :datetime
    add_column :domains, :auctionendtime, :integer
  end
end
