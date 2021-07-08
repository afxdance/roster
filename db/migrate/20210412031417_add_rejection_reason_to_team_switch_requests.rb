class AddRejectionReasonToTeamSwitchRequests < ActiveRecord::Migration[5.1]
  def change
    add_column :team_switch_requests, :rejection_reason, :text
  end
end
