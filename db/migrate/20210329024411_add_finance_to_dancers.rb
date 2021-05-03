class AddFinanceToDancers < ActiveRecord::Migration[5.1]
  def change
    add_column :dancers, :has_paid_dues, :string
    add_column :dancers, :has_bought_tickets, :string
  end
end
