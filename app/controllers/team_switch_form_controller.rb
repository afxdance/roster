class TeamSwitchFormController < ApplicationController
  def index
    @request = TeamSwitchRequest.new
    @intro = "<p><h1><center>ASDF Welcome to AFX Dance, Spring 2019!</center></h1></p>

  <p>If you are viewing this form, it means that you are <b>UNABLE</b> to participate in the PROJECT or TRAINING team that you are <b><u>CURRENTLY ON</b></u> on due to a <b>time conflict</b>. Through this form, you will also be able to DROP from AFX Project/Training this semester.
  <p><b>[DEADLINE FOR SUBMISSION: FRIDAY, 2/15/2019 @ 11:59 PM.] </b>
  <br><b><u>NO EXCEPTIONS!</u></b>

  <p>***NOTE***: If you are currently on the AFX Competitive Team, the drop deadline and process for AFX Comp is separate and does NOT use this form. We urge you to direct all Comp Team matters to your Captains. Thank you!
  <p>If you have any urgent questions, comments, or concerns, please email [afxdanceviceexecutive@gmail.com] ASAP! We will do our best to respond within 24 hours of receiving your email.
  <br>
  <br>

  <br>

  <p><b>ALL FOLLOWING INFORMATION MUST EXACTLY MATCH THE INFORMATION SUBMITTED ON AUDITION DAY:
</b></p>"
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
