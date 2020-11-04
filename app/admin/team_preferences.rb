ActiveAdmin.register_page "Team Preferences" do
  menu label: "Team Preferences", parent: :dancers, if: proc { current_user.admin? }

  page_action :update, method: :post do
    ActiveRecord::Base.transaction do
      redirect_to admin_import_dancers_from_csv_path, notice: "Successfully imported dancers"
    end
  end

  content do
    render "admin/team_preferences"
  end
end
