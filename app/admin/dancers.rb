ActiveAdmin.register Dancer do
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
      :email,
      :phone,
      :gender,
      :year,
      :experience,
    ].compact
  end

  member_action :add_to_team, method: :post do
    ids = params[:id]
    add_helper(ids, current_user)
  end

  member_action :remove_from_team, method: :post do
    ids = params[:id]
    remove_helper(ids, current_user)
  end

  controller do
    def add_helper(ids, current_user)
      # Make sure to use teams since the relation between users and teams is has and belongs to many
      if current_user.teams.nil?
        redirect_to "/admin/dancers", alert: "Your account, #{current_user.email}, is not associated with a team"
      # The find(1) method is basically finding the first team in the user's list of teams(should eventually change to support users with multiple teams)
      elsif current_user.teams.find(1).locked
        redirect_to "/admin/dancers", alert: "#{current_user.teams.find(1).name} is currently locked right now."
      elsif current_user.teams.find(1).can_pick
        # If current_user.team is a training team, checks if all project teams are done picking.
        if current_user.teams.find(1).can_add(ids.length)
          # If current_user.team has not reached maximum picks, add the dancer.
          added = current_user.teams.find(1).add_dancers(ids)
          redirect_to "/admin/dancers", alert: "#{added} has been added to #{current_user.teams.find(1).name}."
        else
          # If current_user.team has hit maximum picks...
          redirect_to "/admin/dancers", alert: "#{current_user.teams.find(1).name} has exceeded the maximum number of picks."
        end
      else
        # If current_user.team is a training team and all project teams are not locked...
        redirect_to "/admin/dancers", alert: "#{current_user.teams.find(1).name} cannot pick right now because project teams are still picking."
      end
    end

    def remove_helper(ids, current_user)
      if current_user.teams.nil?
        redirect_to "/admin/dancers", alert: "Your account, #{current_user.email}, is not asscoiated with a team."
      elsif current_user.teams.find(1).locked
        redirect_to "/admin/dancers", alert: "#{current_user.team.find(1).name} is locked."
      elsif current_user.teams.find(1).can_pick
        # If current_user.team is a training team, checks if all project teams are done picking.
        removed = current_user.teams.find(1).remove_dancers(ids)
        redirect_to "/admin/dancers", alert: "#{removed} have been removed from #{current_user.teams.find(1).name}"
      else
        # Do not know if this is needed, because training teams won't have any dancers if project teams are still picking.
        redirect_to "/admin/dancers", alert: "#{current_user.teams.find(1).name} cannot remove right now because project teams are still picking."
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :email
      f.input :phone
      f.input :gender
      f.input :year
      f.input :experience
    end
    f.actions
  end

  index do
    selectable_column
    column :id
    column :name
    column :email
    column :phone
    column :gender
    column :year
    column :experience

    # Should eventually change the buttons below to support the possiblility of users with multiple teams
    column :add_dancer do |dancer|
      link_to "Add", "/admin/dancers/#{dancer.id}/add_to_team", method: :post
    end

    column :remove_dancer do |dancer|
      link_to "Remove", "/admin/dancers/#{dancer.id}/remove_from_team", method: :post
    end
    actions
  end

  batch_action :add_to_my_team do |ids|
    add_helper(ids, current_user)
  end

  batch_action :remove_from_my_team do |ids|
    remove_helper(ids, current_user)
  end

  show do |dancers|
    panel "Detail" do
      attributes_table_for dancers do
        row :name
        row :email
        row :phone
        row :gender
        row :year
        row :experience
      end
    end
  end
end
