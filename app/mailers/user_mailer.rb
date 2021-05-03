class UserMailer < ApplicationMailer
  default from: ENV["GMAIL_USERNAME"]

  def success_team_switch_email(dancer, old_team_name, new_team, directors)
    @new_team = new_team #saved as instance variable, accessible in view
    @old_team_name = old_team_name #saved as instance variable, accessible in view
    @directors = directors
    #@year = Date.today.year
    #@semester = ("a" if foo) || ("b" if bar) || "c"
    mail(to: dancer.email, subject: 'Team Switch onto ' + new_team.name)
  end

  def reject_team_switch_email(dancer, rejection_reason)
    @rejection_reason = rejection_reason
    mail(to: dancer.email, subject: 'AFX Team Switch')
  end

end
