class TeamSwitchFormController < ApplicationController
  def index
    @request = TeamSwitchRequest.new
    render "team_switch_form/index"
  end

  def create_team_switch_request
    @request = TeamSwitchRequest.new(request_params)
    @request.dancer = find_dancer(@request.name, @request.phone, @request.email)

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
      for r in TeamSwitchRequest.where(dancer: @request.dancer)
        r.update(status: "rejected")
      end

      render "team_switch_form/confirm"
    else
      render "team_switch_form/index"
    end
  end

  # Returns a dancer if name and a contact point (phone OR email) has been filled out properly
  def find_dancer(name, phone, email)
    require 'pry-nav'; binding.pry
    for dancer in Dancer.where("lower(name) = ?", name.downcase)
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
      :available_team_ids,
    )
  end
end
