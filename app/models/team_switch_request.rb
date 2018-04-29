class TeamSwitchRequest < ApplicationRecord
  belongs_to :dancer
  has_and_belongs_to_many :available_teams, class_name: "Team", join_table: :team_switch_requests_available_teams
  belongs_to :old_team, class_name: "Team"
  belongs_to :new_team, class_name: "Team", optional: true
end
