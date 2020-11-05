ActiveAdmin.register_page "Import Preferences" do
  menu label: "Import Preferences", parent: :dancers, if: proc { !current_user.admin? }

  # https://activeadmin.info/10-custom-pages.html
  page_action :update, method: :post do
    csv = CSV.read(params[:csv][:uploaded_file].tempfile, headers: true, encoding: "bom|utf-8")
    errors = []
    ActiveRecord::Base.transaction do
      dancer_preferences = []
      director = current_user.id # Gets the currently logged in user
      teams = Team.all
      myTeamId = nil
      for team in teams
        for user in team.users
          if user.id == director
            myTeamId = team.id
          end
        end
      end
      csv.each do |row|
        dancer_id = row.to_hash['dancer_id']
        dancer_preferences.push(dancer_id)
      end

      pref = TeamPreference.find_by(team_id: myTeamId)
      if pref
        pref.update(team_id: myTeamId, preferences: dancer_preferences)
      else
        TeamPreference.create(team_id: myTeamId, preferences: dancer_preferences)
      end
      redirect_to admin_import_preferences_path, notice: "Successfully imported preferences"
    end
  end

  content do
    form_for :csv, url: { action: "update" }, html: { multipart: true } do |f|
      f.file_field :uploaded_file
      f.submit "Submit"
    end
  end
end
