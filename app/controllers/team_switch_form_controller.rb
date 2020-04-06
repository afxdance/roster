class TeamSwitchFormController < ApplicationController
  def index
    @request = TeamSwitchRequest.new
    # @field1 = FormField.find(1).data.html_safe
    # @field2 = FormField.find(2).data.html_safe
    # @field3 = FormField.find(3).data.html_safe
    # @field4 = FormField.find(4).data.html_safe
    # @field5 = FormField.find(5).data.html_safe
    # @field6 = FormField.find(6).data.html_safe
    # @field7 = FormField.find(7).data.html_safe
    # @field8 = FormField.find(8).data.html_safe
    # @field9 = FormField.find(9).data.html_safe
    # @field10 = FormField.find(10).data.html_safe
    # @field11 = FormField.find(11).data.html_safe
    # @field12 = FormField.find(12).data.html_safe
    # @field13 = FormField.find(13).data.html_safe
    # @field14 = FormField.find(14).data.html_safe
    # @field15 = FormField.find(15).data.html_safe
    # @field16 = FormField.find(16).data.html_safe
    @formfields = FormField.getTeamSwitchFields()
    render "team_switch_form/index"
  end

  def create_team_switch_request
    @request = TeamSwitchRequest.new(request_params)
    @request.dancer = find_dancer(@request.name, @request.phone, @request.email)
    # @field1 = FormField.find(1).data.html_safe
    # @field2 = FormField.find(2).data.html_safe
    # @field3 = FormField.find(3).data.html_safe
    # @field4 = FormField.find(4).data.html_safe
    # @field5 = FormField.find(5).data.html_safe
    # @field6 = FormField.find(6).data.html_safe
    # @field7 = FormField.find(7).data.html_safe
    # @field8 = FormField.find(8).data.html_safe
    # @field9 = FormField.find(9).data.html_safe
    # @field10 = FormField.find(10).data.html_safe
    # @field11 = FormField.find(11).data.html_safe
    # @field12 = FormField.find(12).data.html_safe
    # @field13 = FormField.find(13).data.html_safe
    # @field14 = FormField.find(14).data.html_safe
    # @field15 = FormField.find(15).data.html_safe
    # @field16 = FormField.find(16).data.html_safe
    @formfields = FormField.getTeamSwitchFields()


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
