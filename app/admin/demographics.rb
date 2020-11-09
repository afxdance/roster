ActiveAdmin.register_page "Demographics" do
  menu label: "Demographics", parent: :dancers

  content do
    panel "All Dancers" do
      render partial: "admin/demographics", locals: { team_id: nil }
    end
    panel "Teams" do
      tabs do
        for team in Team.all
          tab team.name do
            render partial: "admin/demographics", locals: { team_id: team.id }
          end
        end
      end
    end
  end
end
