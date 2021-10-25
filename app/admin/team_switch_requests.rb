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

  before_action :role_check

  permit_params do
    [
      :name,
      :email,
      :phone,
      :reason,
      :approved_at,
      :status,
      :old_team_id,
      :new_team_id,
      :dancer_id,
      :rejection_reason,
      available_team_ids: [],
    ].compact
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :email
      f.input :phone
      f.input :reason
      f.input :approved_at, as: :datetime_picker
      f.input :status
      f.input :rejection_reason
      f.input :old_team
      f.input :new_team
      f.input :dancer
      f.input :available_teams
    end
    f.actions
  end

  # https://activeadmin.info/3-index-pages.html
  # https://stackoverflow.com/a/27778755
  # This allows execs to find team switch requests that haven't been processed yet.
  filter :status_present, as: :boolean
  filter :new_team_id_present, as: :boolean
  filter :status, as: :select
  preserve_default_filters!

  scope :all, default: true
  scope("Accepted") { |scope| scope.where("status LIKE ?", "%Accepted%") }
  scope("Rejected") { |scope| scope.where("status LIKE ?", "%Rejected%") }
  scope("Unprocessed") { |scope| scope.where("status IS NULL") }

  member_action :switch_to_team, method: :post do
    team_switch_request_id = params[:id]
    team_id = params[:team_id]
    process_team_switch_request_into_team(team_switch_request_id, team_id)
  end

  member_action :reject, method: :get do
    team_switch_request_id = params[:id]
    send_rejection_email(team_switch_request_id)
  end

  controller do
    # checks if user can view the team switch requests page
    def role_check
      redirect_to "/admin", alert: "You can't view the team switch requests page!!! >:( uwu" unless current_user.can_view_team_switch?
    end

    def action_methods
      if current_user.can_modify_all_teams?
        super
      else
        super - ["edit", "destroy"]
      end
    end

    def back_url
      request.referrer
    end

    def send_rejection_email(team_switch_request_id)
      # Is the request valid?
      team_switch_request = TeamSwitchRequest.find(team_switch_request_id)
      if team_switch_request.nil?
        redirect_to :back, alert: "Team switch #{team_switch_request_id} does not exist."
        return
      end
      dancer = team_switch_request.dancer
      # Does the dancer exist?
      if dancer.nil?
        redirect_to :back, alert: "Team switch request not attached to a dancer."
        return
      end

      # check the status of the request
      if !team_switch_request.status.blank?
        redirect_to :back, alert: "Team switch request id #{team_switch_request_id} for dancer #{dancer.name} has been fulfilled already." and return
      end

      # check the rejection reason field is null
      if team_switch_request.rejection_reason.nil?
        redirect_to :back, alert: "Team switch request id #{team_switch_request_id} for dancer #{dancer.name} has an empty rejection reason. Fill out the rejection reason by editing the team switch request and re-click the 'Reject' button." and return
      end

      # Else send rejection email
      # Send rejection email
      begin
        UserMailer.reject_team_switch_email(dancer, team_switch_request.rejection_reason).deliver_now
      rescue Net::SMTPAuthenticationError,
        Net::SMTPServerBusy,
        Net::SMTPSyntaxError,
        Net::SMTPFatalError,
        Net::SMTPUnknownError,
        Errno::ECONNREFUSED => e
        # do something with the messages in exception object e
            flash[:error] = "Email not sent, please manually email dancer #{dancer.name} at email #{dancer.email} with rejection reason #{team_switch_request.rejection_reason}."
      end

      # Set approved time, and status of the request
      team_switch_request.update(
        approved_at: Time.now,
        status: "Rejected",
      )
      # Due to Configuration over Convention, rails looks for the "reject" view. Must redirect back to the index and alert
      redirect_to :back, notice: "Team switch request id #{team_switch_request_id} for dancer #{dancer.name} has been successfully rejected." and return

    end

    def process_team_switch_request_into_team(team_switch_request_id, team_id)
      # Is the request valid?
      team_switch_request = TeamSwitchRequest.find(team_switch_request_id)
      if team_switch_request.nil?
        redirect_to :back, alert: "Team switch #{team_switch_request_id} does not exist."
        return
      end

      # Is the new team valid?
      new_team = Team.find(team_id)
      if new_team.nil?
        redirect_to :back, alert: "Team #{team_id} does not exist."
        return
      end

      # 1. Check for permission
      # Does the user have permission to modify the team?
      if !current_user.can_modify_all_teams?
        redirect_to :back, alert: "You don't have permission to modify all teams."
        return
      end

      dancer = team_switch_request.dancer
      # Does the dancer exist?
      if dancer.nil?
        redirect_to :back, alert: "Team switch request not attached to a dancer."
        return
      end

      # 3. Check that the dancer is currently on 1 or 0 teams
      if !(0..1).cover? dancer.teams.length
        redirect_to :back, alert: "Dancer must be on 0 or 1 teams. Dancer is in these teams: #{dancer.teams.map(&:name)}"
        return
      end

      # 2. Check that the person's team is still the request's old team
      if team_switch_request.old_team != dancer.teams.first && dancer.teams.first&.level != Team::DROP
        redirect_to :back, alert:
          "The dancer isn't on the team they were on when they submitted that form. " \
          "When they submitted the request, they were on: #{team_switch_request.old_team&.name}. " \
          "Now they are on: #{dancer.teams.first&.name}."
        return
      end

      old_team = team_switch_request.old_team

      # 4. Check that we're not switching a training team dancer into a project team
      if old_team&.level != Team::PROJECT && new_team&.level == Team::PROJECT
        redirect_to :back, alert: "Dancer was not on a project team, and you're attempting to switch them onto a project team."
        return
      end

      # check the status of the request
      if !team_switch_request.status.blank?
        redirect_to :back, alert: "Team switch request id #{team_switch_request_id} for dancer #{dancer.name} has been fulfilled already." and return
      end

      # 3. Do the following in a transaction so that it either all succeeds or all fails
      DancerTeam.transaction do
        # 3a. Remove the dancer from the old team
        DancerTeam.where(dancer: dancer, team: old_team).delete_all

        # 3b. Remove the dancer from the drop team if needed
        DancerTeam.where(dancer: dancer, team: dancer.teams.where(level: Team::DROP)).delete_all

        # 3c. Switch the dancer onto the new team, but do it by making a new DancerTeam with reason "team switch form"
        DancerTeam.create!(dancer: dancer, team: new_team, reason: "Team switch")

        # 3d. Set the new team, approved time, and status of the request
        team_switch_request.update(
          new_team: new_team,
          approved_at: Time.now,
          status: "Accepted",
        )

        begin
          UserMailer.success_team_switch_email(dancer, old_team.name, new_team).deliver_now
        rescue Net::SMTPAuthenticationError,
          Net::SMTPServerBusy,
          Net::SMTPSyntaxError,
          Net::SMTPFatalError,
          Net::SMTPUnknownError,
          Errno::ECONNREFUSED => e
          # do something with the messages in exception object e
              flash[:error] = "Email not sent, please manually email dancer #{dancer.name} at email #{dancer.email}. "
        end

        redirect_to :back, notice: "#{dancer.name} has been switched into #{new_team.name}."
      end
    end
  end

  index do
    selectable_column
    # https://github.com/activeadmin/activeadmin/issues/1995#issuecomment-15846811
    TeamSwitchRequest.content_columns.each { |col| column col.name.to_sym }
    column :old_team
    column :new_team
    column :current_team do |team_switch_request|
      team_switch_request&.dancer&.teams&.first
    end

    column :available_teams do |team_switch_request|
      dancer = team_switch_request&.dancer
      content_tag(:div, style: "white-space: nowrap") do
        team_switch_request.available_teams.each do |team|
          link = link_to("/admin/team_switch_requests/#{team_switch_request.id}/switch_to_team?" + { team_id: team.id }.to_query, method: :post, title: "Switch dancer onto this team") do
            "+"
          end
          team_size = team.dancers.length
          team_same_gender_size = current_user.can_view_sensitive_dancer_fields? ?
                                    team.dancers.where(gender: dancer&.gender).length :
                                    0
          team_same_gender = team_same_gender_size / (team_size + 0.0001) * 100
          team_same_year_size = team.dancers.where(year: dancer&.year).length
          team_same_year = team_same_year_size / (team_size + 0.0001) * 100
          concat content_tag(:div,
                             "[#{link}] #{team.name} (#{team_size} G:#{team_same_gender.to_i}% Y:#{team_same_year.to_i}%)".html_safe)
        end
      reject = link_to("/admin/team_switch_requests/#{team_switch_request.id}/reject", method: :get) do "Reject" end
        concat content_tag(:div, "#{reject}".html_safe)
      end
    end

    actions
  end
end
