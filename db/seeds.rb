# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# User.delete_all
# Dancer.delete_all
# Team.delete_all

User.create_with(id: 1,
                 username: "admin",
                 password: "password",
                 password_confirmation: "password",
                 role: "admin",
).find_or_create_by(id: 1)

User.create_with(id: 2,
                 username: "young cai",
                 password: "password",
                 password_confirmation: "password",
                 role: "director",
                 name: "Young Cai",
).find_or_create_by(id: 2)
dancer_extra_fields = {
  exp_interest: "not important rn",
  tech_interest: "not important rn",
  camp_interest: "not important rn",
  reach_workshop_interest: "not important rn",
  reach_news_interest: "not important rn",
}
# Dancer.create!(name: "Peter Le",
#                email: "peter@peter.peter",
#                phone: "pet-erp-eter",
#                gender: "peter",
#                year: "1",
#                dance_experience: "peter",
#                **dancer_extra_fields)
# Dancer.create!(name: "Alice Wu",
#                email: "alice@alice.alice",
#                phone: "ali-cea-lice",
#                gender: "alice",
#                year: "1",
#                dance_experience: "alice",
#                **dancer_extra_fields)
# Dancer.create!(name: "Stella Wang",
#                email: "stella@stella.stella",
#                phone: "ste-lla-wang",
#                gender: "stella",
#                year: "2",
#                dance_experience: "stella",
#                **dancer_extra_fields)
Dancer.create_with(
  phone: "pet-erp-eter",
  gender: "peter",
  year: "3",
  dance_experience: "no",
  **dancer_extra_fields,
).find_or_create_by(name: "Evelyn Liu", email: "peter@peter.peter")
Team.create_with(
  level: "Project",
  practice_time: "Tuesday,Thursday",
  locked: false,
  maximum_picks: 100,
  practice_location: "Underhill,Hass",
).find_or_create_by(name: "AFX Help")
Team.create_with(
  level: "Project",
  practice_time: "Wednesday",
  locked: false,
  maximum_picks: 50,
  practice_location: "Sproul",
).find_or_create_by(name: "AFX Oasis")
# Team.create(name: "AFX Help",
#              level: "Project",
#              practice_time: "all the time",
#              locked: false,
#              maximum_picks: 100)
# Team.create(name: "AFX Oasis",
#              level: "Project",
#              practice_time: "never",
#              locked: false,
#              maximum_picks: 50)

# Form Fields
FormField.delete_all
FormField.create!(id: 1, data: "<h2>AFX TEAM SWITCH/DROP FORM</h2>")
FormField.create!(id: 2, data: "<p><h1><center>Welcome to AFX Dance, Fall 2077!</center></h1></p>")
FormField.create!(id: 3, data: "<p>If you are viewing this form, it means that you are <b>UNABLE</b> to participate in the PROJECT or TRAINING team that you are <b><u>CURRENTLY ON</b></u> on due to a <b>time conflict</b>. Through this form, you will also be able to DROP from AFX Project/Training this semester.
<p><b>[DEADLINE FOR SUBMISSION: SATURDAY, 9/21/2019 @ 11:59 PM.] </b>
<br><b><u>NO EXCEPTIONS!</u></b>

<p>***NOTE***: If you are currently on AFX Competitive Team, the drop deadline and process is separate and does NOT use this form. We urge you to direct all Dance Camp matters to your Captains. Thank you!

<p>If you have any urgent questions, comments, or concerns, please email [afxdanceviceexecutive@gmail.com] ASAP! We will do our best to respond within 24 hours of receiving your email.
<br>
<br>

<br>")
FormField.create!(id: 4, data: "<p><b>ALL FOLLOWING INFORMATION MUST EXACTLY MATCH THE INFORMATION SUBMITTED ON AUDITION DAY:
</b></p>
  <br>")
FormField.create!(id: 5, data: "<p><h3><center><b><u>PROJECT TEAM SWITCH</u></b></center></h3>")
FormField.create!(id: 6, data: "  <b><i>[You may ONLY answer this if you are currently on a Project Team.]</i></b>
  <p><b><u>TO SWITCH INTO A DIFFERENT AFX PROJECT TEAM:</u></b>
    <br>
  If you would like to <b>switch into a different Project Team</b>, please select ALL other Project Teams’ times that you can attend:")
FormField.create!(id: 7, data: "<p><b><u>TO SWITCH INTO AN AFX TRAINING TEAM FROM YOUR AFX PROJECT TEAM:</u></b>
    <br>
    If you would like to <b>switch into a Training Team</b>, please refer to the “Training Team Switch” portion of this form.

  <p><b><u>NOTE</u></b>: You may <b>NOT</b> select BOTH Project team time and Training team time preferences. We process each request individually and will not be processing your request to switch into a different Project and Training team simultaneously. </p>

  <p><b>Failure to comply with any instructions will lead to your team switch request being dismissed.
</b></p>")
FormField.create!(id: 8, data: "<p><h3><center><b><u>TRAINING TEAM SWITCH</u></b></center></h3>")
FormField.create!(id: 9, data: "<b><i>[This portion is for all members currently placed on a Training Team OR on a Project Team who would like to switch into a Training Team.]
</i></b>

<p><b><u>TO SWITCH AFX TRAINING TEAMS:</u></b>
    <br>
  If you would like to <b>join or switch into a different Training Team</b>, please select ALL Training Teams’ times (AT LEAST <b>TWO</b>) that you can attend:")
FormField.create!(id: 10, data: "<p><b>Failure to comply with any instructions will lead to your team switch request being dismissed.</b></p><br><br>")
FormField.create!(id: 11, data: "<p><h3><center><b><u>DROP FROM AFX PROJECT/TRAINING</u></b></center></h3>")
FormField.create!(id: 12, data: "<b><i>[ONLY ANSWER THIS QUESTION IF YOU HAVE CHOSEN TO DROP FROM AFX DANCE’S PROJECT AND TRAINING TEAMS THIS SEMESTER.]</i></b><br>")
FormField.create!(id: 13, data: "<p><br><b>Once you select this box, you may not re-join AFX this semester. Please consult with your directors to discuss your circumstances before making this decision. You may also email afxdanceviceexecutive@gmail.com for further questions!</b></p><br><br>")
FormField.create!(id: 14, data: "<p><b>What is your reason for switching into a different team or dropping from AFX? Please explain your time conflict and what prevents you from attending your current team’s practices.*  </b></p>")
FormField.create!(id: 15, data: "<p><b>We urge you to PLEASE double-check all of your contact information and answers as inputting incorrect information may lead to an unattended request, a rejected request, or a drop from AFX. Have you reviewed all of your responses carefully?*</b></p>")
FormField.create!(id: 16, data: "<p>Again, if you have any further questions, please email afxdanceviceexecutive@gmail.com and we will try to respond within 24 hours. You will receive an email with the results once your team switch or drop request has been successfully processed. Please check your email’s spam folder in case the email is delivered there. All notices and results are delivered ONLY from afxdanceviceexecutive@gmail.com. Thank you for your patience!</p>

    <p><i>All information processed through this form will be confidential and be kept within the Executive Board. We greatly appreciate your cooperation.</i></p>")

# Backup fields
FormField.create!(id: 17, data: "<h2>AFX TEAM SWITCH/DROP FORM</h2>")
FormField.create!(id: 18, data: "<p><h1><center>Welcome to AFX Dance, Fall 2077!</center></h1></p>")
FormField.create!(id: 19, data: "<p>If you are viewing this form, it means that you are <b>UNABLE</b> to participate in the PROJECT or TRAINING team that you are <b><u>CURRENTLY ON</b></u> on due to a <b>time conflict</b>. Through this form, you will also be able to DROP from AFX Project/Training this semester.
<p><b>[DEADLINE FOR SUBMISSION: SATURDAY, 9/21/2019 @ 11:59 PM.] </b>
<br><b><u>NO EXCEPTIONS!</u></b>

<p>***NOTE***: If you are currently on AFX Competitive Team, the drop deadline and process is separate and does NOT use this form. We urge you to direct all Dance Camp matters to your Captains. Thank you!

<p>If you have any urgent questions, comments, or concerns, please email [afxdanceviceexecutive@gmail.com] ASAP! We will do our best to respond within 24 hours of receiving your email.
<br>
<br>

<br>")
FormField.create!(id: 20, data: "<p><b>ALL FOLLOWING INFORMATION MUST EXACTLY MATCH THE INFORMATION SUBMITTED ON AUDITION DAY:
</b></p>
  <br>")
FormField.create!(id: 21, data: "<p><h3><center><b><u>PROJECT TEAM SWITCH</u></b></center></h3>")
FormField.create!(id: 22, data: "  <b><i>[You may ONLY answer this if you are currently on a Project Team.]</i></b>
  <p><b><u>TO SWITCH INTO A DIFFERENT AFX PROJECT TEAM:</u></b>
    <br>
  If you would like to <b>switch into a different Project Team</b>, please select ALL other Project Teams’ times that you can attend:")
FormField.create!(id: 23, data: "<p><b><u>TO SWITCH INTO AN AFX TRAINING TEAM FROM YOUR AFX PROJECT TEAM:</u></b>
    <br>
    If you would like to <b>switch into a Training Team</b>, please refer to the “Training Team Switch” portion of this form.

  <p><b><u>NOTE</u></b>: You may <b>NOT</b> select BOTH Project team time and Training team time preferences. We process each request individually and will not be processing your request to switch into a different Project and Training team simultaneously. </p>

  <p><b>Failure to comply with any instructions will lead to your team switch request being dismissed.
</b></p>")
FormField.create!(id: 24, data: "<p><h3><center><b><u>TRAINING TEAM SWITCH</u></b></center></h3>")
FormField.create!(id: 25, data: "<b><i>[This portion is for all members currently placed on a Training Team OR on a Project Team who would like to switch into a Training Team.]
</i></b>

<p><b><u>TO SWITCH AFX TRAINING TEAMS:</u></b>
    <br>
  If you would like to <b>join or switch into a different Training Team</b>, please select ALL Training Teams’ times (AT LEAST <b>TWO</b>) that you can attend:")
FormField.create!(id: 26, data: "<p><b>Failure to comply with any instructions will lead to your team switch request being dismissed.</b></p><br><br>")
FormField.create!(id: 27, data: "<p><h3><center><b><u>DROP FROM AFX PROJECT/TRAINING</u></b></center></h3>")
FormField.create!(id: 28, data: "<b><i>[ONLY ANSWER THIS QUESTION IF YOU HAVE CHOSEN TO DROP FROM AFX DANCE’S PROJECT AND TRAINING TEAMS THIS SEMESTER.]</i></b><br>")
FormField.create!(id: 29, data: "<p><br><b>Once you select this box, you may not re-join AFX this semester. Please consult with your directors to discuss your circumstances before making this decision. You may also email afxdanceviceexecutive@gmail.com for further questions!</b></p><br><br>")
FormField.create!(id: 30, data: "<p><b>What is your reason for switching into a different team or dropping from AFX? Please explain your time conflict and what prevents you from attending your current team’s practices.*  </b></p>")
FormField.create!(id: 31, data: "<p><b>We urge you to PLEASE double-check all of your contact information and answers as inputting incorrect information may lead to an unattended request, a rejected request, or a drop from AFX. Have you reviewed all of your responses carefully?*</b></p>")
FormField.create!(id: 32, data: "<p>Again, if you have any further questions, please email afxdanceviceexecutive@gmail.com and we will try to respond within 24 hours. You will receive an email with the results once your team switch or drop request has been successfully processed. Please check your email’s spam folder in case the email is delivered there. All notices and results are delivered ONLY from afxdanceviceexecutive@gmail.com. Thank you for your patience!</p>

    <p><i>All information processed through this form will be confidential and be kept within the Executive Board. We greatly appreciate your cooperation.</i></p>")

# give admin access to all seeded teams
User.find(1).teams = Team.all
# young cai is the director of AFX Help
User.find(2).teams = [Team.first]

Rails.env.development?
