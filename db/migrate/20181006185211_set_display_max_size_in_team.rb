class SetDisplayMaxSizeInTeam < ActiveRecord::Migration[5.1]
  def self.up
    add_column :teams, :display, :boolean, :default => true
    add_column :teams, :max_size, :integer, :default => 2
  end

  def self.down

  end
end
