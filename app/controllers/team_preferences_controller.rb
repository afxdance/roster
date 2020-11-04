class TeamPreferencesController < ApplicationController
  def create_teams

    team_size = params['team_size'].to_i
    result = TeamPreference.generateTeams(team_size)
    if !result[:errors].empty?
      puts result[:errors]
      return
    end

    puts result

    # @request = TeamSwitchRequest.new(request_params)
    # @request.dancer = find_dancer(@request.name, @request.phone, @request.email)
    # @formfields = FormField.find_team_switch_fields
    # if @request.dancer
    #   if @request.dancer.teams.empty?
    #     @request.old_team = nil
    #   elsif @request.dancer.teams.length == 1
    #     @request.old_team = @request.dancer.teams[0]
    #   else
    #     raise "Dancer on more than one team"
    #   end
    # end

    # if @request.save
    #   # Make current request open
    #   @request.status = "open"

    #   # Reject all previous requests
    #   for request in TeamSwitchRequest.where(dancer: @request.dancer)
    #     next if request.id == @request.id

    #     request.update(status: "Rejected: newer request submitted")
    #   end
    #   render "team_switch_form/confirm"
    # else
    #   render "team_switch_form/index"
    # end
  end
end
