class TeamSwitchRequest < ApplicationRecord
  belongs_to :dancer
  has_and_belongs_to_many :available_teams, class_name: 'Team', join_table: :team_switch_requests_available_teams
  belongs_to :old_team, class_name: 'Team'
  belongs_to :new_team, class_name: 'Team'

  def accept
    dancer_to_switch = Dancer.where(name: name).first
    available_teams = []
    availability.each do |key, value|
    if value == "1"
      available_teams += [Team.find(key)]
    end

    # default: switch dancer onto first team on list -- should be optimized for team balancing
    new_team = available_teams[0]

    ActiveRecord::Base.transaction do
    	self.new_team = new_team
    	# save! throws exception if attempt to save invalid record
    	self.save!

    	unless dancer.teams.length == 1
    		raise "Dancer on more than one team"
    	end

    	dancer.teams.delete_all
    	dancer.teams.append(new_team)
    	dancer.save!
    end
	end
end
end
