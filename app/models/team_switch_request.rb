class TeamSwitchRequest < ApplicationRecord
  # https://blog.bigbinary.com/2016/02/15/rails-5-makes-belong-to-association-required-by-default.html
  ActiveAdmin.register TeamSwitchRequest do
    menu if: proc { current_user.admin? }
  end

  belongs_to :dancer, optional: true
  has_and_belongs_to_many :available_teams, class_name: "Team", join_table: :team_switch_requests_available_teams
  belongs_to :old_team, class_name: "Team", optional: true
  belongs_to :new_team, class_name: "Team", optional: true

  validates :dancer, presence: { message: ": You are not in our directory, please revise your information" }

  TABLE_VISIBLE_FIELDS = [
    :name,
    :email,
    :phone,
    :approved_at,
    :old_team,
    :new_team,
  ].freeze

  # Return relevant team switch requests, either the dancer just joined or just left
  # If the new team isn't nil then that means the request has been processed
  def self.get_processed_team_switch_requests(team_id)
    TeamSwitchRequest.where.not(new_team_id: nil).where(new_team_id: team_id)
                     .or(TeamSwitchRequest.where.not(new_team_id: nil).where(old_team_id: team_id))
  end
end
