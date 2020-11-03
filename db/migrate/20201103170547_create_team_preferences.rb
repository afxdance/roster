class CreateTeamPreferences < ActiveRecord::Migration[5.1]
  def change
    create_table :team_preferences do |t|
      t.integer :team_id
      t.text :preferences
      t.text :initial_team

      t.timestamps
    end
  end
end
