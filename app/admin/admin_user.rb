ActiveAdmin.register AdminUser do
  permit_params :email, :names, :password, :password_confirmation, :admin_type, :team, :team_id

  action_item :semester, only: :index do
    link_to "New Semester", "/admin/admin_users/new_semester", data: { confirm:
    "This deletes current teams, dancers, and casting groups. Are you sure?" }
  end

  collection_action :new_semester, method: :get do
    admin_type = current_admin_user.admin_type
    if admin_type != "admin"
      flash[:alert] = "You do not have sufficient permissions to do this!"
    else
      Team.destroy_all
      Dancer.destroy_all
      CastingGroup.destroy_all
      AdminUser.where("admin_type = ? OR admin_type = ?", "project", "training").destroy_all
      Team.reset_pk_sequence
      Dancer.reset_pk_sequence
      CastingGroup.reset_pk_sequence
      flash[:notice] = "Semesters have been reset."
    end
    redirect_to "/admin/admin_users"
  end

  index do
    selectable_column
    id_column
    column :email
    column :admin_type
    column :names
    column :teams
    actions
  end

  form do |f|
    f.inputs "Admin Details" do
      f.input :email
      f.input :names
      f.input :admin_type
      f.input :team
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

  show do
    panel "Details" do
      attributes_table_for admin_user do
        row :admin_type
        row :names
      end
    end

    panel "Team" do
      attributes_table_for admin_user.team do
        row :name
        row :project
      end
    end
    active_admin_comments
  end

  form do |f|
    f.inputs do
      f.input :email
      f.input :names
      f.input :admin_type
      f.input :team
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

  filter :admin_type
  filter :names

  config.per_page = 15
end
