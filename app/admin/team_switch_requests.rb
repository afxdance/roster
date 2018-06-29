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

  index do
    selectable_column
    # https://github.com/activeadmin/activeadmin/issues/1995#issuecomment-15846811
    TeamSwitchRequest.content_columns.each { |col| column col.name.to_sym }
    column :available_teams do |team_switch_request|
      team_switch_request.available_teams.map do |team|
        content_tag :div do
          link_to("/admin/teams/#{team.id}") do
            team.name
          end
        end
      end.join.html_safe
    end
    actions
  end
end
