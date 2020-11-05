class TeamPreferencesController < ApplicationController
  def create_teams

    team_size = params['team_size'].to_i
    result = TeamPreference.generateTeams(team_size)

    if !result[:errors].empty?
      redirect_to admin_team_preferences_path(:errors => result[:errors])
    else
      redirect_to admin_team_preferences_path(:teams => result[:teams])
    end
  end

  def delete_teams
    ActiveRecord::Base.connection.execute("DELETE from 'dancers_teams'")
    redirect_to admin_team_preferences_path(:message => "All teams have been cleared")
  end
end