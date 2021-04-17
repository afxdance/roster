class UserMailer < ApplicationMailer
  default from: ENV["GMAIL_USERNAME"]

  def team_switch_email(dancer, old_team_name, new_team, directors)
    @new_team = new_team #saved as instance variable, accessible in view
    @old_team_name = old_team_name #saved as instance variable, accessible in view
    @directors = directors
    mail(to: dancer.email, subject: 'Team Switch onto ' + new_team.name)
  end
end
