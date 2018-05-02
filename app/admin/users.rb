ActiveAdmin.register User do
  permit_params :email, :password, :password_confirmation, team_ids: [] # Necessary in order to properly link users and teams

  index do
    selectable_column
    id_column
    column :email
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    column "Teams" do |user|
      user.teams.map do |team|
        link_to team.name, admin_team_path(team)
      end
    end
    actions
  end

  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form do |f|
    f.inputs do
      f.input :email
      f.input :password
      f.input :password_confirmation
      # Creates the selection menu so the user can choose a team
      f.input :teams, collection: Team.all.map { |team| [team.name, team.id] }
    end
    f.actions
  end
end
