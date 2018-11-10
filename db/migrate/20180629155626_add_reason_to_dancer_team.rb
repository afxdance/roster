class AddReasonToDancerTeam < ActiveRecord::Migration[5.1]
  def change
    add_column :dancers_teams, :reason, :string
  end
end
