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

  # Dancer.table_exists? &&

  # Skip during rake db:load:schema, because Dancer.columns isn't available yet
  if Dancer.table_exists?
    columns = Dancer.columns.map(&:name).map(&:to_sym)
    permit_params columns
  end
  # Dancer.table_exists? && Dancer.columns.each do |column|
  #   # require 'pry-nav'; binding.pry
  #   if !["id", "created_at", "updated_at"].include?(column.name)
  #     puts column.name
  #     permit_params column.name.to_sym
  #   end
  # end

  member_action :add_to_team, method: :post do
    dancer_id = params[:id]
    team_id = params[:team_id]
    add_dancers_to_team([dancer_id], team_id)
  end

  member_action :remove_from_team, method: :post do
    dancer_id = params[:id]
    team_id = params[:team_id]
    remove_dancers_from_team([dancer_id], team_id)
  end

  controller do
    def action_methods
      if current_user.can_modify_dancer_fields?
        super
      else
        super - ["edit", "destroy"]
      end
    end

    def back_url
      request.referrer
    end

    def add_dancers_to_team(dancer_ids, team_id)
      team = Team.find(team_id)

      # Is the team valid?
      if team.nil?
        redirect_to :back, alert: "Team #{team_id} does not exist."

      # Does the user have permission to modify the team?
      elsif !current_user.teams.include? team
        redirect_to :back, alert: "You can't modify #{team.name}."

      # Is the team locked?
      elsif team.locked?
        redirect_to :back, alert: "#{team.name} is currently locked right now."

      # If training team, have project teams finished picking?
      elsif !team.turn_to_add?
        redirect_to :back, alert: "#{team.name} cannot pick right now because project teams are still picking."

      elsif !team.has_space_for? dancer_ids
        # If current_user.team has hit maximum picks...
        redirect_to :back, alert: "#{team.name} has exceeded the maximum number of picks."

      else
        # If all is ok, add the dancers.
        result = team.add_dancers(dancer_ids)
        redirect_to :back, alert: "#{result[:added].map(&:name)} has been added to #{team.name}."

      end
    end

    def remove_dancers_from_team(dancer_ids, team_id)
      team = Team.find(team_id)

      # Is the team valid?
      if team.nil?
        redirect_to :back, alert: "Team #{team_id} does not exist."

      # Does the user have permission to modify the team?
      elsif !current_user.teams.include? team
        redirect_to :back, alert: "You can't modify #{team.name}."

      # Is the team locked?
      elsif team.locked?
        redirect_to :back, alert: "#{team.name} is currently locked right now."

      else
        # If all is ok, remove the dancers.
        result = team.remove_dancers(dancer_ids)
        redirect_to "/admin/dancers", alert: "#{result[:removed].map(&:name)} has been removed from #{team.name}"

      end
    end
  end

  form do |f|
    f.inputs do
      current_user.accessible_dancer_fields.each do |field|
        f.input field
      end
    end
    f.actions
  end

  index do
    selectable_column
    current_user.table_visible_dancer_fields.each do |field|
      column field
    end

    # Should eventually change the buttons below to support the possiblility of users with multiple teams
    column :add_dancer do |dancer|
      # If the dancer is already on a team, hide the "Add to team" button.
      next if dancer.teams.any?

      current_user.teams.map do |team|
        content_tag :div do
          link_to("/admin/dancers/#{dancer.id}/add_to_team?" + { team_id: team.id }.to_query, method: :post) do
            "+ #{team.name}"
          end
        end
      end.join.html_safe
    end

    column :remove_dancer do |dancer|
      dancer.teams.map do |team|
        content_tag :div do
          link_to("/admin/dancers/#{dancer.id}/remove_from_team?" + { team_id: team.id }.to_query, method: :post) do
            "- #{team.name}"
          end
        end
      end.join.html_safe
    end

    actions
  end

  current_user_teams_lambda = lambda do
    {
      team: current_user.teams.map { |team| [team.name, team.id] },
    }
  end

  batch_action :add, form: current_user_teams_lambda do |dancer_ids, inputs|
    team_id = inputs[:team]
    add_dancers_to_team(dancer_ids, team_id)
  end

  batch_action :remove, form: current_user_teams_lambda do |dancer_ids, inputs|
    team_id = inputs[:team]
    remove_dancers_from_team(dancer_ids, team_id)
  end

  show do |dancer|
    panel "Detail" do
      attributes_table_for dancer do
        current_user.accessible_dancer_fields.each do |field|
          row field
        end
      end
    end
  end

  action_item :audition_form, only: :index do
    link_to "Audition Form", "/audition"
  end

  collection_action :next_audition_number, method: :get do
    if !current_user.can_modify_next_dancer_id?
      flash[:alert] = "You do not have sufficient permissions to do this!"
    else
      begin
        flash[:notice] = "The next audition number is: #{Dancer.next_id}"
      rescue RuntimeError => e
        flash.now[:alert] = e.message
      end
    end
    redirect_to "/admin/dancers"
  end

  action_item :next_audition_number_button, only: :index do
    link_to "Next Audition Number", "/admin/dancers/next_audition_number"
  end
end
