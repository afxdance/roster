class TeamSwitchFormController < ApplicationController
  def index
    @request = TeamSwitchRequest.new
    @formfields = FormField.find_team_switch_fields
    render "team_switch_form/index"
  end

  def create_team_switch_request
    @request = TeamSwitchRequest.new(request_params)
    @request.dancer = find_dancer(@request.name, @request.phone, @request.email)
    @formfields = FormField.find_team_switch_fields
    if @request.dancer
      if @request.dancer.teams.empty?
        @request.old_team = nil
      elsif @request.dancer.teams.length == 1
        @request.old_team = @request.dancer.teams[0]
      else
        raise "Dancer on more than one team"
      end
    end

    if @request.save
      # Make current request open
      @request.status = "open"

      # Reject all previous requests
      for request in TeamSwitchRequest.where(dancer: @request.dancer)
        next if request.id == @request.id

        request.update(status: "Rejected: newer request submitted")
      end

      render "team_switch_form/confirm"
    else
      render "team_switch_form/index"
    end
  end

  # Returns a dancer if name and a contact point (phone OR email) has been filled out properly
  def find_dancer(name, phone, email)
    for dancer in Dancer.where("replace(lower(name), ' ', '') = ?", name.downcase.delete(" "))
      if phone == dancer.phone || email == dancer.email
        return dancer
      end
    end
    nil
  end

  def request_params
    params.require(:team_switch_request).permit(
      :email,
      :name,
      :phone,
      :reason,
      # https://stackoverflow.com/a/16555975
      available_team_ids: [],
    )
  end
end
