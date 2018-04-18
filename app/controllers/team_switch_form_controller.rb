class TeamSwitchFormController < ApplicationController

  def index
    @request = TeamSwitchRequest.new
    render 'team_switch_form/index'
  end

  def create_team_switch_request
    @request = TeamSwitchRequest.new(request_params)
    #require 'pry'; binding.pry
    @request.dancer = find_dancer(@request.name, @request.phone, @request.email)
    if @request.dancer != nil
      if @request.dancer.teams.length == 0
        @request.original_team = nil
      elsif @request.dancer.teams.length == 1
        @request.original_team = @request.dancer.teams[0]
      else
        raise RuntimeError.new("Dancer on more than one team")
      end
    end

    if @request.save
      #Make current request open
      @request.status = "open"

      #Reject all previous requests
      for r in @request.where(dancer: @request.dancer)
        r.status = "auto-rejected"
      end

      render "team_switch_form/confirm"
    else
      render "team_switch_form/index"
    end
  end

  # Returns a dancer if name and a contact point (phone OR email) has been filled out properly
  def find_dancer(name, phone, email)
    for dancer in Dancer.all
      if name.casecmp(dancer.name) == 0 and (phone == dancer.phone or email == dancer.email)
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
      availability: params[:team_switch_request][:availability] ? params[:team_switch_request][:availability].keys : nil
    )
  end

end
