ActiveAdmin.register Team do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  scope_to :current_user

  permit_params do
    [
      :name,
      :project,
      :practice_time,
      :locked,
      :maximum_picks,
      :level,
      # Necessary in order to properly link users and teams
      user_ids: [],
    ].compact
  end

  form do |f|
    f.inputs do
      f.input :name
      # Creates a drop down that allows you to choose from "Project" and "Training"
      f.input :level, collection: [Team::PROJECT, Team::TRAINING, Team::DROP]
      # Creates a selection menu so the team can be linked to a user
      f.input :users
      f.input :practice_time,
              label: [
                "Practice time",
                "(EX. Thu 7-8:30, Sat 4-5:30)",
                "If add a space at the beginning or leave this blank, this team will be hidden in the team switch form.",
              ].join("<br>").html_safe
      f.input :locked
      f.input :maximum_picks
    end
    f.actions
  end

  index do
    selectable_column
    column :name
    column :level
    column :practice_time
    column :locked
    column :maximum_picks
    # Allows us to view the Users that are connected to the team
    column "User" do |team|
      team.users.map do |user|
        link_to user.username, admin_user_path(user)
      end.join(", ").html_safe
    end
    # Allows us to view the Dancers that are connected to the team
    column "Number of Dancers" do |team|
      team.dancers.length
    end
    actions
  end

  show do
    panel "Detail" do
      attributes_table_for team do
        row :name
        row :level
        row :practice_time
        row :locked
        row :maximum_picks
      end
    end

    panel "Dancers" do
      tabs do
        for tab_name, sort_order in [
          ["Most recently added first", "added_at DESC"],
          ["Most recently added last", "added_at ASC"],
          ["Sorted alphabetically", "lower(trim(name))"],
        ]
          tab tab_name do
            table_for team.dancers_with_added_at_added_reason.order(sort_order) do
              current_user.table_visible_dancer_fields.each do |field|
                column field
              end
              column :added_at
              column :added_reason
              column :actions do |dancer|
                [
                  link_to("View", admin_dancer_path(dancer)),
                  link_to("/admin/teams/#{team.id}/drop_dancer?" + { dancer_id: dancer.id }.to_query, method: :post, title: "Drop dancer from this team", data: { confirm: "Drop #{dancer.name}?" }) do
                    "Drop"
                  end,
                ].join(" ").html_safe
              end
            end
          end
        end
      end
    end
  end

  member_action :drop_dancer, method: :post do
    team_id = params[:id]
    dancer_id = params[:dancer_id]
    drop_dancer_from_team(dancer_id, team_id)
  end

  controller do
    def back_url
      request.referrer
    end

    def drop_dancer_from_team(dancer_id, team_id)
      # Is the dancer valid?
      dancer = Dancer.find(dancer_id)
      if !dancer_id
        redirect_to :back, alert: "Dancer #{dancer_id} does not exist."
        return
      end

      # Is the team valid?
      team = Team.find(team_id)
      if !team_id
        redirect_to :back, alert: "Team #{team_id} does not exist."
        return
      end

      # Does the user have permission to modify the team?
      if !current_user.teams.include?(team)
        redirect_to :back, alert: "You don't have permission to modify this team."
        return
      end

      drop_team = Team.drop_teams.first
      TeamSwitchRequest.create!(
        name: dancer.name,
        email: dancer.email,
        phone: dancer.phone,
        reason: "(Drop button in admin panel)",
        approved_at: Time.now,
        status: "Approved",
        old_team: team,
        new_team: drop_team,
        dancer: dancer,
        available_teams: [drop_team],
      )

      DancerTeam.where(dancer: dancer, team: team).delete_all
      DancerTeam.create!(dancer: dancer, team: drop_team, reason: "Dropped")

      redirect_to :back, notice: "#{dancer.name} has been switched into #{drop_team.name}."
    end
  end
end
