class UserMailer < ApplicationMailer
  default from: ENV["GMAIL_USERNAME"]

  def team_switch_email(dancer, old_team_name, new_team_name)
    @dancer = dancer
    @new_team_name = new_team_name #saved as instance variable, accessible in view
    @old_team_name = old_team_name #saved as instance variable, accessible in view

    mail(to: dancer.email, subject: 'Team Switch onto ' + new_team_name)
  end
end
