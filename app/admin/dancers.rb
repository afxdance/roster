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
      :reason,
      :approved_at,
      :status,
    ].compact
  end
  member_action :add_dancer, :method => :post do
    ids = params[:id]
    add_helper(ids)
  end

  member_action :remove_dancer, :method => :post do
    ids = params[:id]
    remove_helper(ids)
  end

  # controller do
  #   def add_helper(ids)
  #
  #     added = teams.
  #
  #
  #   def remove_helper(ids)
  #
  #   end
  # end

  form do |f|
    f.inputs do
      f.input :name
      f.input :email
      f.input :phone
      # f.input :reason
      # f.input :approved_at
      # f.input :status
    end
    f.actions
  end

  index do
    selectable_column
    column :id
    column :name
    column :email
    column :phone
    column :add_dancer do |dancers|

    end
    column :remove_dancer do |dancers|

    end
    actions
  end

  show do |dancers|
    panel "Detail" do
      attributes_table_for dancers do
        row :name
        row :email
        row :phone
        row :reason
        row :approved_at
        row :status
      end
    end
  end
end
