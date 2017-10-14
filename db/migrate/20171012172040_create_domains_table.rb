class CreateDomainsTable < ActiveRecord::Migration
  def change
    create_table :domains do |t|
      t.string :domainName
      t.string :link
      t.string :auctionType
      t.datetime :auctionEndTime
      t.string :price
      t.integer :numberOfBids
      t.integer :pageviews
      t.string :valuation
      t.string :monthlyParkingRevenue
      t.boolean :isAdult
      
    end
  end
end
