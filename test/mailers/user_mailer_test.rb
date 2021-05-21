require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "team switch approved email" do
    # Set up an request based on the fixture three in team_switch_requests.yml
    request = team_switch_requests(:three)
    # Set up an email using the order contents
    dancer = Dancer.where(name: request["name"], email: request["email"])
    email = UserMailer.with(dancer: dancer, new_team_name: "new_team_name", old_team_name: "old_team_name")


    # Check if the email is sent
    assert_emails 1 do
      email.deliver_now
    end

    # Check the contents are correct
    assert_equal "afxteamswitch@gmail.com", email.from
    assert_equal "clu@berkeley.edu", email.to
    assert_equal "Team Switch onto new_team_name", email.subject


    # dancer, "Old AFX team", "New AFX team"
    # assert_match order.name, email.html_part.body.encoded
    # assert_match order.name, email.text_part.body.encoded
    # assert_match order.email, email.html_part.body.encoded

  end
end
