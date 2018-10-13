require "test_helper"

class TeamSwitchRequestTest < Capybara::Rails::TestCase
  # test "the truth" do
  #   assert true
  # end

  include ActiveJob::TestHelper

  def setup
    @one = dancers :one
    @two = dancers :two
    @project = teams :project
    @training = teams :training
    @onerequest = onerequest :team_switch_requests
    @tworequest = tworequest :team_switch_requests
  end

  test 'whitespace in name' do
    process_team_switch_request_into_team(team_switch_request_id, team_id)
    visit teamswitch_path

    assert page.has_content?(@one.title)
    assert page.has_content?(@two.title)
  end

end
