ActiveAdmin.register_page "Demographics" do
  menu label: "Demographics", parent: :dancers

  content do
    panel format("All Dancers (%<count>s)", count: Dancer.count) do
      render partial: "admin/demographics", locals: { team_id: nil }
    end
    panel "Teams" do
      tabs do
        for team in Team.all
          tab format("%<name>s (%<count>s)", name: team.name, count: Dancer.joins(:dancers_teams).where(dancers_teams: { team_id: team.id }).count) do
            render partial: "admin/demographics", locals: { team_id: team.id }
          end
        end
      end
    end
  end
end
