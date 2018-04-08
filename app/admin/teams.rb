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
      :type,
      :practice_time,
      :locked,
    ].compact
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :type
      f.input :practice_time,
              label: "Practice time<br>(EX. Thu 7-8:30, Sat 4-5:30)".html_safe
      f.input :locked
    end
    f.actions
  end

  index do
    selectable_column
    column :name
    column :type
    column :practice_time
    column :locked
    actions
  end

  show do
    panel "Detail" do
      attributes_table_for team do
        row :name
        row :type
        row :practice_time
        row :locked
      end
    end
  end
end
