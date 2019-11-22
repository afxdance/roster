class AddConfirmEmailToDancers < ActiveRecord::Migration[5.1]
  def change
    add_column :dancers, :confirm_email_sent, :boolean, :default => false
  end
end
