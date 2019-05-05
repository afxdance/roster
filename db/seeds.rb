# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

dancer_extra_fields = { exp_interest: "not important rn",
                        tech_interest: "not important rn",
                        camp_interest: "not important rn" }

User.create!(username: "admin",
             password: "password",
             password_confirmation: "password",
             role: "admin")

User.create!(username: "young cai",
             password: "password123",
             password_confirmation: "password123",
             role: "director")

Dancer.create!(name: "Peter Le",
               email: "peter@peter.peter",
               phone: "pet-erp-eter",
               gender: "peter",
               year: "1",
               dance_experience: "peter",
               **dancer_extra_fields)
Dancer.create!(name: "Alice Wu",
               email: "alice@alice.alice",
               phone: "ali-cea-lice",
               gender: "alice",
               year: "1",
               dance_experience: "alice",
               **dancer_extra_fields)
Dancer.create!(name: "Stella Wang",
               email: "stella@stella.stella",
               phone: "ste-lla-wang",
               gender: "stella",
               year: "2",
               dance_experience: "stella",
               **dancer_extra_fields)

Team.create!(name: "AFX Help",
             level: "Project",
             practice_time: "all the time",
             locked: false,
             maximum_picks: 100)
Team.create!(name: "AFX Oasis",
             level: "Project",
             practice_time: "never",
             locked: false,
             maximum_picks: 50)

FormField.create!(text: "<p><h1><center>Welcome to AFX Dance, Spring 2019!</center></h1></p>    <p>If you are viewing this form, it means that you are <b>UNABLE</b> to participate in the PROJECT or TRAINING team that you are <b><u>CURRENTLY ON</b></u> on due to a <b>time conflict</b>. Through this form, you will also be able to DROP from AFX Project/Training this semester.   <p><b>[DEADLINE FOR SUBMISSION: FRIDAY, 2/15/2019 @ 11:59 PM.] </b>   <br><b><u>NO EXCEPTIONS!</u></b>    <p>***NOTE***: If you are currently on the AFX Competitive Team, the drop deadline and process for AFX Comp is separate and does NOT use this form. We urge you to direct all Comp Team matters to your Captains. Thank you!   <p>If you have any urgent questions, comments, or concerns, please email [afxdanceviceexecutive@gmail.com] ASAP! We will do our best to respond within 24 hours of receiving your email.   <br>   <br>    <br>    <p><b>ALL FOLLOWING INFORMATION MUST EXACTLY MATCH THE INFORMATION SUBMITTED ON AUDITION DAY: </b></p>",
            identity: "intro")

FormField.create!(text: "<p><h3><center><b><u>PROJECT TEAM SWITCH</u></b></center></h3>   <b><i>[You may ONLY answer this if you are currently on a Project Team.]</i></b>   <p><b><u>TO SWITCH INTO A DIFFERENT AFX PROJECT TEAM:</u></b>     <br>   If you would like to <b>switch into a different Project Team</b>, please select ALL other Project Teams’ times that you can attend:",
            identity: "projectTS1")

FormField.create!(text: "<p><b><u>TO SWITCH INTO AN AFX TRAINING TEAM FROM YOUR AFX PROJECT TEAM:</u></b>     <br>     If you would like to <b>switch into a Training Team</b>, please refer to the “Training Team Switch” portion of this form.    <p><b><u>NOTE</u></b>: You may <b>NOT</b> select BOTH Project team time and Training team time preferences. We process each request individually and will not be processing your request to switch into a different Project and Training team simultaneously. </p>    <p><b>Failure to comply with any instructions will lead to your team switch request being dismissed. </b></p>",
            identity: "projectTS2")

FormField.create!(text: "<p><h3><center><b><u>TRAINING TEAM SWITCH </u></b></center></h3>   <b><i>[This portion is for all members currently placed on a Training Team OR on a Project Team who would like to switch into a Training Team.] </i></b>  <p><b><u>TO SWITCH AFX TRAINING TEAMS:</u></b>     <br>   If you would like to <b>join or switch into a different Training Team</b>, please select ALL Training Teams’ times (AT LEAST <b>TWO</b>) that you can attend:",
            identity: "trainingTS1")

FormField.create!(text: "<p><b>Failure to comply with any instructions will lead to your team switch request being dismissed. </b></p>",
            identity: "trainingTS2")

FormField.create!(text: "<p><h3><center><b><u>DROP FROM AFX PROJECT/TRAINING  </u></b></center></h3>   <b><i>[ONLY ANSWER THIS QUESTION IF YOU HAVE CHOSEN TO DROP FROM AFX DANCE’S PROJECT AND TRAINING TEAMS THIS SEMESTER.]  </i></b>",
            identity: "drop1")

FormField.create!(text: "<p><br><b>Once you select this box, you may not re-join AFX this semester. Please consult with your directors to discuss your circumstances before making this decision. You may also email afxdanceviceexecutive@gmail.com for further questions! </b></p>",
            identity: "drop2")

FormField.create!(text: "<p><b>What is your reason for switching into a different team or dropping from AFX? Please explain your time conflict and what prevents you from attending your current team’s practices.* </b></p>",
            identity: "reason")

FormField.create!(text: "<p><b>We urge you to PLEASE double-check all of your contact information and answers as inputting incorrect information may lead to an unattended request, a rejected request, or a drop from AFX. Have you reviewed all of your responses carefully?*</b>",
            identity: "review")

FormField.create!(text: "<p>If you have any further questions, please email afxdanceviceexecutive@gmail.com and we will try to respond within 24 hours. You will receive an email with the results once your team switch or drop request has been successfully processed. Please check your email’s spam folder in case the email is delivered there. All notices and results are delivered ONLY from afxdanceviceexecutive@gmail.com. Thank you for your patience!      <p><i>All information processed through this form will be confidential and be kept within the Executive Board. We greatly appreciate your cooperation.",
            identity: "final")

FormField.create!(text: "We strongly recommend entering your primary email. Note that berkeley.com and berkeley.edu are very different!",
            identity: "email")

FormField.create!(text: "MUST be XXX-XXX-XXXX format",
            identity: "phone")

FormField.create!(text: "This information is used to ensure teams are balanced, diverse, and inclusive. The form is processed by an algorithm and your response will be kept confidential within the AFX Dance Executive Board.",
            identity: "gender")

FormField.create!(text: "EXP is a dance organization partnered with AFX that focuses on dancer growth through urban and hip-hop fundamentals and freestyle training! Please indicate if you are interested in receiving more information via email!",
            identity: "expinterest")

FormField.create!(text: "AFX Tech is a project-based technical organization that contributes to the Berkeley Dance Community through a variety of outlets, from front-end web development/design to back-end algorithmic programming.",
            identity: "techinterest")


# give admin access to all seeded teams
User.find(1).teams = Team.all

Rails.env.development?
