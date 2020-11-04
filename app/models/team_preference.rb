require 'set'
require 'json'

class TeamPreference < ApplicationRecord
  def self.generateTeams(maximum_size)

    result = {
      errors: "",
      teams: []
    }

    allTeams = Team.all
    allPreferences = TeamPreference.all

    if allTeams.length() != allPreferences.length()
      result[:errors] = "Not all teams have entered their preferences"
      return result
    end

    teamIds = [] # team id's
    teamPreferences = [] # each team's preferences
    teamPreferencesIndex = [] # where each team is on their preferences list
    teamPicks = [] # the list of each team while being picked
    teamDone = [] # boolean if the team has reached the end of their preferences
    for row in allPreferences
      teamIds.push(row.team_id)
      teamPreferences.push(JSON.parse(row.preferences))
      teamPreferencesIndex.push(0)
      teamPicks.push([])
      teamDone.push(false)
    end

    selected = Set.new # list of dancers who have already been selected
    picking = 0 # index of who is picking
    nextPicker = 1 # modifier of who relatively gets to pick next

    while teamDone.any? { |done| done == false }
      current_team = teamPicks[picking]
      current_preferences = teamPreferences[picking]
      current_index = teamPreferencesIndex[picking]
      current_done = teamDone[picking]

      # If the team is not done picking
      if !current_done
        # While the team is not done with their preferences list and we haven't found a dancer this picking round for them
        found = false
        while current_index < current_preferences.length() && !found
          dancer = current_preferences[current_index]
          # If the dancer's id has not already been selected, add them to the current team and exit
          if !selected.include?(dancer)
            selected.add(dancer)
            current_team.push(dancer)
            if current_team.length() == maximum_size
              teamDone[picking] = true;
            end
            found = true
          end
          current_index += 1
        end
        teamPreferencesIndex[picking] = current_index
      end

      # If the team reaches the end of their preferences list, then they are done, otherwise, we increase their preferences index by 1
      if current_index >= current_preferences.length()
        teamDone[picking] = true;
      end

      # Handles the snaking of picking
      if nextPicker == 1 && picking == teamPicks.length()-1
        nextPicker = -1
      elsif nextPicker == -1 && picking == 0
        nextPicker = 1
      else
        # sets who gets to pick next
        picking += nextPicker
      end
    end

    finalTeams = {}

    teamIds.each_with_index do |id, index|
      finalTeams[id] = teamPicks[index]
    end

    result[:teams] = finalTeams
    return result

  end
end
