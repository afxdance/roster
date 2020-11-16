ActiveAdmin.register_page "Team Preferences" do
  menu label: "Team Preferences", parent: :dancers, if: proc { current_user.admin? }

  page_action :create_teams, method: :post do
    team_size = params["team_size"].to_i
    result = TeamPreference.generate_teams(team_size)

    if !result[:errors].empty?
      redirect_to admin_team_preferences_path(errors: result[:errors])
    else

      preferences = TeamPreference.all
      for pref in preferences
        pref.update(initial_team: result[:teams][pref.team_id])
      end

      redirect_to admin_team_preferences_path(teams: result[:teams], limbo: result[:limbo])
    end
  end

  page_action :delete_teams, method: :post do
    # clears our dancer_teams table
    ActiveRecord::Base.connection.execute("DELETE from 'dancers_teams'")
    # clears our "initial_team" column in team_preferences table
    preferences = TeamPreference.all
    for pref in preferences
      pref.update(initial_team: nil)
    end

    redirect_to admin_team_preferences_path(message: "All teams have been cleared")
  end

  content do
    render "admin/team_preferences"
  end
end
