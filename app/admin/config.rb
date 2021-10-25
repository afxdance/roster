# TODO this page is fucked

ActiveAdmin.register_page "Config" do
  menu label: "Config", parent: :dancers, if: proc { current_user.admin? }

  page_action :create_project_teams, method: :post do
    team_size = params["team_size"].to_i
    result = TeamPreference.generate_project_teams(team_size)

    if !result[:errors].empty?
      redirect_to admin_team_preferences_path(errors: result[:errors])
    else
      # clears out dancers_teams table
      DancerTeam.delete_all

      # populates "initial_team" column in team_preferences table
      preferences = TeamPreference.all
      for pref in preferences
        team_id = pref.team_id
        pref.update(initial_team: result[:teams][team_id])

        # populates the dancers_teams table
        for dancer in result[:teams][team_id]
          DancerTeam.create(dancer_id: dancer, team_id: team_id)
        end
      end

      redirect_to admin_team_preferences_path(teams: result[:teams], limbo: result[:limbo])
    end
  end

  page_action :delete_teams, method: :post do
    # clears out dancers_teams table
    DancerTeam.delete_all
    # clears our "initial_team" column in team_preferences table
    preferences = TeamPreference.all
    for pref in preferences
      pref.update(initial_team: nil)
    end

    redirect_to admin_team_preferences_path(delete_teams_message: "All teams have been cleared")
  end

  content do
    # checks to see if teams have changed from initial creation and if so, disables the "Create Teams" button
    preferences = TeamPreference.all
    disable = false
    for pref in preferences
      if pref.initial_team
        initial_team = Set.new(JSON.parse(pref.initial_team))
        team_id = pref.team_id
        current_team = Set.new
        results = DancerTeam.where(team_id: team_id)
        for row in results
          current_team.add(row["dancer_id"].to_s)
        end
        # initial teams must have been set and changed for this button to disable
        if initial_team != current_team
          disable = true
          break
        end
      end
    end
    render partial: "admin/team_preferences", locals: { disable_button: disable }
  end
end
