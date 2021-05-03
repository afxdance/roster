class AddAdditionalFinanceToDancers < ActiveRecord::Migration[5.1]
  def change
    add_column :dancers, :dues_changed_at, :datetime
    add_column :dancers, :tickets_changed_at, :datetime
    add_column :dancers, :dues_approved_by, :string
    add_column :dancers, :tickets_approved_by, :string
  end
end
