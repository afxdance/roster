ActiveAdmin.register_page "Team Preferences" do
  menu label: "Team Preferences", parent: :dancers, if: proc { current_user.admin? }

  page_action :create_teams, method: :post do
    team_size = params["team_size"].to_i
    result = TeamPreference.generate_teams(team_size)

    if !result[:errors].empty?
      redirect_to admin_team_preferences_path(errors: result[:errors])
    else
      # clears out dancers_teams table
      ActiveRecord::Base.connection.execute("DELETE from 'dancers_teams'")

      # populates "initial_team" column in team_preferences table
      preferences = TeamPreference.all
      for pref in preferences
        team_id = pref.team_id
        pref.update(initial_team: result[:teams][team_id])

        # populates the dancers_teams table
        for dancer in result[:teams][team_id]
          ActiveRecord::Base.connection.execute("INSERT INTO 'dancers_teams' (dancer_id, team_id, created_at, updated_at) VALUES (#{dancer}, #{team_id}, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)")
        end
      end

      redirect_to admin_team_preferences_path(teams: result[:teams], limbo: result[:limbo])
    end
  end

  page_action :delete_teams, method: :post do
    # clears out dancers_teams table
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
