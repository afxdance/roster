class ChangeUserDirectorColumnName < ActiveRecord::Migration[5.1]
  def change
    rename_column :users, :director_name, :name
  end
end
