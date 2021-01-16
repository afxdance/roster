class CreateTeamPreferences < ActiveRecord::Migration[5.1]
  def change
    create_table :team_preferences do |t|
      t.text :preferences
      t.text :initial_team

      t.belongs_to :team, index: true

      t.timestamps
    end
  end
end
