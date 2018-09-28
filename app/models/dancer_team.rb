class DancerTeam < ActiveRecord::Base
  self.table_name = "dancers_teams"

  belongs_to :dancer
  belongs_to :team
end
