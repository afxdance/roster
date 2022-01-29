ActiveAdmin.register_page "Import Preferences" do
  menu label: "Import Preferences", parent: :dancers, if: proc { current_user.admin? or current_user.director? }

  # https://activeadmin.info/10-custom-pages.html
  page_action :update, method: :post do
    csv = CSV.read(params[:csv][:uploaded_file].tempfile, headers: true, encoding: "bom|utf-8")
    ActiveRecord::Base.transaction do
      # Makes assumption that a user can only be the director of 1 team at a time
      input_team_name = params[:team]
      input_team_id = Team.where(name: input_team_name).ids.first
      # if team name invalid or does not belong to the user
      if !current_user.teams.ids.include?(input_team_id)
        redirect_to admin_import_preferences_path, alert: "Invalid team name: #{input_team_name}"

      else
        # creates set of all valid dancer id's
        dancers = Dancer.all
        all_dancers = Set.new
        for dancer in dancers
          all_dancers.add(dancer.id.to_s)
        end

        dancer_preferences = Set.new
        csv.each do |row|
          dancer_id = row.to_hash["dancer_id"]
          # checks that dancer_id is a valid dancer id or if they have duplicate dancer id's on their preferences
          if !all_dancers.include?(dancer_id)
            redirect_to admin_import_preferences_path, alert: "Invalid dancer id: #{dancer_id}"
            return
          elsif dancer_preferences.include?(dancer_id)
            next
          else
            dancer_preferences.add(dancer_id)
          end
        end

        dancer_preferences = dancer_preferences.to_a

        pref = TeamPreference.find_by(team_id: input_team_id)
        if pref
          pref.update(team_id: input_team_id, preferences: dancer_preferences)
        else
          TeamPreference.create(team_id: input_team_id, preferences: dancer_preferences)
        end
        redirect_to admin_import_preferences_path, notice: "Successfully imported preferences"
      end
    end
  end

  content do
    form_for :csv, url: { action: "update" }, html: { multipart: true } do |f|
      f.input name: :team, required: true, placeholder: "Team"
      f.file_field :uploaded_file
      f.submit "Submit"
    end
  end
end
