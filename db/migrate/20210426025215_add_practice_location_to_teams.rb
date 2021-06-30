class AddPracticeLocationToTeams < ActiveRecord::Migration[5.1]
  def change
    add_column :teams, :practice_location, :string
  end
end
