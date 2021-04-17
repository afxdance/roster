class AddDirectorNameToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :director_name, :string
  end
end
