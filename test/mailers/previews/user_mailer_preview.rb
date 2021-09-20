# Preview all emails at http://localhost:3000/rails/mailers/user_mailer

class UserMailerPreview < ActionMailer::Preview
  def success_team_switch_email
    # Set up a temporary order for the preview
    dancer = Dancer.new(id: 1, team_ids: [1], name: "Christine Lu", email: "clu@berkeley.edu", phone: "000-000-0000")
    user1 = User.create(id: 1, role: "director", name: "Evelyn Liu")
    user2 = User.create(id: 2, role: "director", name: "Dustin Luong")
    team = Team.create(id: 100, name: "new team", practice_time: "Tuesday,Thursday", locked: "no",
                       practice_location: "Underhill,Hass", users: [user1, user2])
    UserMailer.success_team_switch_email(dancer, "Old AFX team", team)
  end

  def reject_team_switch_email
    # Set up a temporary order for the preview
    dancer = Dancer.new(name: "christine lu", email: "clu@berkeley.edu", phone: "000-000-0000")
    UserMailer.reject_team_switch_email(dancer, "no reason")
  end
end
