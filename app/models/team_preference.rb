require "set"
require "json"

class TeamPreference < ApplicationRecord
  belongs_to :team

  def self.generate_project_teams(maximum_size)
    result = {
      errors: "",
      teams: [],
      extras: [],
    }

    all_teams = Team.project_teams
    all_preferences = TeamPreference.all

    if all_teams.length != all_preferences.length
      result[:errors] = "Not all teams have entered their preferences"
      return result
    end

    team_ids = [] # team id's
    team_preferences = [] # each team's preferences
    team_preferences_index = [] # where each team is on their preferences list
    team_picks = [] # the list of each team while being picked
    team_done = [] # boolean if the team has reached the end of their preferences
    all_preferenced_dancers = Set.new # all unique dancers in atleast one team's preferences
    for row in all_preferences
      dancers_in_preferences = JSON.parse(row.preferences)
      team_ids.push(row.team_id)
      team_preferences.push(dancers_in_preferences)
      team_preferences_index.push(0)
      team_picks.push([])
      team_done.push(false)
      all_preferenced_dancers.merge(dancers_in_preferences)
    end

    selected = Set.new # list of dancers who have already been selected
    picking = 0 # inde_i of who is picking
    next_picker = 1 # modifier of who relatively gets to pick next

    while team_done.any? { |done| done == false }
      current_team = team_picks[picking]
      current_preferences = team_preferences[picking]
      current_index = team_preferences_index[picking]
      current_done = team_done[picking]

      # If the team is not done picking
      if !current_done
        # While the team is not done with their preferences list and we haven't found a dancer this picking round for them
        found = false
        while current_index < current_preferences.length && !found
          dancer = current_preferences[current_index]
          # If the dancer's id has not already been selected, add them to the current team and exit
          if !selected.include?(dancer)
            selected.add(dancer)
            current_team.push(dancer)
            if current_team.length == maximum_size
              team_done[picking] = true
            end
            found = true
          end
          current_index += 1
        end
        team_preferences_index[picking] = current_index
      end

      # If the team reaches the end of their preferences list, then they are done, otherwise, we increase their preferences index by 1
      if current_index >= current_preferences.length
        team_done[picking] = true
      end

      # Handles the snaking of picking
      if next_picker == 1 && picking == team_picks.length - 1
        next_picker = -1
      elsif next_picker == -1 && picking == 0
        next_picker = 1
      else
        # sets who gets to pick next
        picking += next_picker
      end
    end

    # dancers that were on preferences that were not selected
    dancers_in_limbo = all_preferenced_dancers - selected
    result[:limbo] = dancers_in_limbo.to_a

    final_teams = {}

    team_ids.each_with_index do |id, index|
      final_teams[id] = team_picks[index]
    end

    result[:teams] = final_teams
    return result
  end
end
