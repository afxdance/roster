class SetDisplayMaxSizeInTeam < ActiveRecord::Migration[5.1]
  def change
    add_column :teams, :display, :boolean, default: true
    add_column :teams, :max_size, :integer, default: 2
  end
end
