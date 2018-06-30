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
      f.input :users, collection: User.all.map { |user| [user.username, user.id] }
      f.input :practice_time,
              label: "Practice time<br>(EX. Thu 7-8:30, Sat 4-5:30)".html_safe
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
                link_to "View", admin_dancer_path(dancer)
              end
            end
          end
        end
      end
    end
  end
end
