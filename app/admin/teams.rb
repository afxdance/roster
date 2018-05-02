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
      user_ids: [],
    ].compact
  end

  form do |f|
    f.inputs do
      f.input :name
      # Creates a drop down that allows you to choose from "Project" and "Training"
      f.input :type_of, collection: ["Project", "Training"]
      f.input :users, collection: User.all.map { |user| [user.email, user.id] }
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
    column :type_of
    column :practice_time
    column :locked
    column :maximum_picks
    # Allows us to view the Users that are connected to the team
    column "User" do |team|
      team.users.map do |user|
        link_to user.email, admin_user_path(user)
      end
    end
    # Allows us to view the Dancers that are connected to the team
    column "Dancers" do |team|
      team.dancers.map do |dancer|
        link_to dancer.name, admin_dancer_path(dancer)
      end
    end
    actions
  end

  show do
    panel "Detail" do
      attributes_table_for team do
        row :name
        row :type_of
        row :practice_time
        row :locked
        row :maximum_picks
      end
    end
  end
end
