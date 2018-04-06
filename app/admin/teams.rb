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
      :practice_time,
      :locked,
      :project,
    ].compact
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :practice_time
      f.input :locked
    end
    f.actions
  end

  index do
    selectable_column
    column :name
    column :practice_time
    column :locked
    column :project
    actions
  end

  show do
    panel "Detail" do
      attributes_table_for team do
        row :name
        row :practice_time
        row :locked
        row :project
      end
    end
  end
end
