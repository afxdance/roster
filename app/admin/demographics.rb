ActiveAdmin.register_page "Demographics" do
  menu label: "Demographics", parent: :dancers

  content do
    panel "All Dancers (%s)" %[Dancer.count] do
      render partial: "admin/demographics", locals: { team_id: nil }
    end
    panel "Teams" do
      tabs do
        for team in Team.all
          tab "%s (%s)" %[team.name, Dancer.joins(:dancers_teams).where(dancers_teams: {team_id: team.id}).count] do
            render partial: "admin/demographics", locals: { team_id: team.id }
          end
        end
      end
    end
  end
end
