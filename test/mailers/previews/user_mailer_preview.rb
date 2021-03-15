# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def team_switch_email
    # Set up a temporary order for the preview
    dancer = Dancer.new(name: "christine lu", email: "clu@berkeley.edu", phone: "000-000-0000")
    UserMailer.team_switch_email(dancer, "Old AFX team", "New AFX team")
  end
end
