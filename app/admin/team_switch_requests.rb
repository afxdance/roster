ActiveAdmin.register TeamSwitchRequest do
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
    ].compact
  end

  controller do
    def approve_helper(ids)
      admin_type = current_admin_user.admin_type
      if admin_type != 'admin'
        flash[:alert] = 'You do not have sufficient permissions to do this!'
      else
        ids.each do |id|
          switch_request = TeamSwitchRequest.find(id)
          switch_request.accept
        end
        #redirect_to '/admin/team_switch_requests'
      end
    end
  end

  batch_action :approve do |ids|
    approve_helper(ids)
  end
end
