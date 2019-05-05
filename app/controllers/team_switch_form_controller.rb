class TeamSwitchFormController < ApplicationController
  def index
    @request = TeamSwitchRequest.new
    @intro = get_text("intro")
    @projectTS1 = get_text("projectTS1")
    @projectTS2 = get_text("projectTS2")
    @trainingTS1 = get_text("trainingTS1")
    @trainingTS2 = get_text("trainingTS2")
    @drop1 = get_text("drop1")
    @drop2 = get_text("drop2")
    @reason = get_text("reason")
    @review = get_text("review")
    @final = get_text("final")
    render "team_switch_form/index"
    
#     @intro_default = "<p><h1><center>ASDF Welcome to AFX Dance, Spring 2019!</center></h1></p>

#   <p>If you are viewing this form, it means that you are <b>UNABLE</b> to participate in the PROJECT or TRAINING team that you are <b><u>CURRENTLY ON</b></u> on due to a <b>time conflict</b>. Through this form, you will also be able to DROP from AFX Project/Training this semester.
#   <p><b>[DEADLINE FOR SUBMISSION: FRIDAY, 2/15/2019 @ 11:59 PM.] </b>
#   <br><b><u>NO EXCEPTIONS!</u></b>

#   <p>***NOTE***: If you are currently on the AFX Competitive Team, the drop deadline and process for AFX Comp is separate and does NOT use this form. We urge you to direct all Comp Team matters to your Captains. Thank you!
#   <p>If you have any urgent questions, comments, or concerns, please email [afxdanceviceexecutive@gmail.com] ASAP! We will do our best to respond within 24 hours of receiving your email.
#   <br>
#   <br>

#   <br>

#   <p><b>ALL FOLLOWING INFORMATION MUST EXACTLY MATCH THE INFORMATION SUBMITTED ON AUDITION DAY:
# </b></p>"
#     @projectTS1_default = "<p><h3><center><b><u>asdfPROJECT TEAM SWITCH</u></b></center></h3>
#   <b><i>[You may ONLY answer this if you are currently on a Project Team.]</i></b>
#   <p><b><u>TO SWITCH INTO A DIFFERENT AFX PROJECT TEAM:</u></b>
#     <br>
#   If you would like to <b>switch into a different Project Team</b>, please select ALL other Project Teams’ times that you can attend:"
#     @projectTS2_default = "<p><b><u>asdfTO SWITCH INTO AN AFX TRAINING TEAM FROM YOUR AFX PROJECT TEAM:</u></b>
#     <br>
#     If you would like to <b>switch into a Training Team</b>, please refer to the “Training Team Switch” portion of this form.

#   <p><b><u>NOTE</u></b>: You may <b>NOT</b> select BOTH Project team time and Training team time preferences. We process each request individually and will not be processing your request to switch into a different Project and Training team simultaneously. </p>

#   <p><b>Failure to comply with any instructions will lead to your team switch request being dismissed.
# </b></p>"
#     @trainingTS1_default = "<p><h3><center><b><u>asdfTRAINING TEAM SWITCH
# </u></b></center></h3>
#   <b><i>[This portion is for all members currently placed on a Training Team OR on a Project Team who would like to switch into a Training Team.]
# </i></b>

# <p><b><u>TO SWITCH AFX TRAINING TEAMS:</u></b>
#     <br>
#   If you would like to <b>join or switch into a different Training Team</b>, please select ALL Training Teams’ times (AT LEAST <b>TWO</b>) that you can attend:"
#     @trainingTS2_default = "<p><b>asdfFailure to comply with any instructions will lead to your team switch request being dismissed.
# </b></p>"
#     @drop1_default = "<p><h3><center><b><u>asdfDROP FROM AFX PROJECT/TRAINING

# </u></b></center></h3>
#   <b><i>[ONLY ANSWER THIS QUESTION IF YOU HAVE CHOSEN TO DROP FROM AFX DANCE’S PROJECT AND TRAINING TEAMS THIS SEMESTER.]

# </i></b>"
#     @drop2_default = "<p><br><b>asdfOnce you select this box, you may not re-join AFX this semester. Please consult with your directors to discuss your circumstances before making this decision. You may also email afxdanceviceexecutive@gmail.com for further questions!
# </b></p>"
#     @reason_default = "<p><b>asdfWhat is your reason for switching into a different team or dropping from AFX? Please explain your time conflict and what prevents you from attending your current team’s practices.*
# </b></p>"
#     @review_default = "<p><b>asdfWe urge you to PLEASE double-check all of your contact information and answers as inputting incorrect information may lead to an unattended request, a rejected request, or a drop from AFX. Have you reviewed all of your responses carefully?*</b>"
#     @final_default = "<p>asdfIf you have any further questions, please email afxdanceviceexecutive@gmail.com and we will try to respond within 24 hours. You will receive an email with the results once your team switch or drop request has been successfully processed. Please check your email’s spam folder in case the email is delivered there. All notices and results are delivered ONLY from afxdanceviceexecutive@gmail.com. Thank you for your patience!

#     <p><i>All information processed through this form will be confidential and be kept within the Executive Board. We greatly appreciate your cooperation."
    
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

  # gets text for dynamic form
  def get_text(id)
    for formfield in FormField.where("identity = ?", (id).delete(" "))
      return formfield.text
    end
    nil
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
