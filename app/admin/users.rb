ActiveAdmin.register User do
  menu if: proc { current_user.admin? }
  before_action :role_check

  permit_params(
    :username,
    :password,
    :password_confirmation,
    :role,
    team_ids: [], # Necessary in order to properly link users and teams
  )

  controller do
    # checks if user can view the users page
    def role_check
      redirect_to "/admin", alert: "You can't view the users page!!! >:( uwu" unless current_user.can_view_users?
    end
  end

  index do
    selectable_column
    id_column
    column :username
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    column :role
    column "Teams" do |user|
      user.teams.map do |team|
        link_to team.name, admin_team_path(team)
      end.join(", ").html_safe
    end
    actions
  end

  filter :username
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at
  filter :role

  form do |f|
    f.inputs do
      f.input :username
      f.input :password
      f.input :password_confirmation
      # Creates the selection menu so the user can choose a team
      f.input :teams, collection: Team.all.map { |team| [team.name, team.id] }
      f.input :role, as: :select, collection: User.roles.keys, include_blank: false, allow_blank: false
    end
    f.actions
  end
end
