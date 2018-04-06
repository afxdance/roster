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
      # :reason,
      # :approved_at,
      # :status,
    ].compact
  end

  member_action :add_to_team, method: :post do
    ids = params[:id]
    add_helper(ids)
  end

  member_action :remove_from_team, method: :post do
    ids = params[:id]
    remove_helper(ids)
  end

  controller do
    def add_helper(ids)
      redirect_to '/admin/dancers', :alert => "to add dancers at index #{ids}"
    end

    def remove_helper(ids)
      redirect_to '/admin/dancers', :alert => "to remove dancers at index #{ids}"
    end
  end

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
    # column :reason
    # column :approved_at
    # column :status
    column :add_dancer do |dancer|
      link_to "Add", "/admin/dancers/#{dancer.id}/add_to_team" , method: :post
    end
    column :remove_dancer do |dancer|
      link_to "Remove", "/admin/dancers/#{dancer.id}/remove_from_team" , method: :post
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
