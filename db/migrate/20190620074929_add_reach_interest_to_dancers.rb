class AddReachInterestToDancers < ActiveRecord::Migration[5.1]
  def change
    add_column :dancers, :reach_workshop_interest, :string
    add_column :dancers, :reach_news_interest, :string
  end
end
