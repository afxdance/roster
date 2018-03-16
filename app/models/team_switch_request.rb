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

    dict = TeamSwitchRequest.new.probe_possibilities(available_teams, dancer_to_switch)
    best_team = TeamSwitchRequest.new.choose_team(dict)
    new_team = Team.where(name: best_team).first

    ActiveRecord::Base.transaction do
    	self.new_team = new_team
    	# save! throws exception if attempt to save invalid record
    	self.save!

    	unless dancer.teams.length < 2
    		raise "Dancer on more than one team"
    	end

    	dancer.teams.delete_all
    	dancer.teams.append(new_team)
    	dancer.save!
    end
	end
end
end
