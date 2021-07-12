require "test_helper"

class TeamTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "concat time and location" do
    team = Team.new(name: "AFX Help",
                    level: "Project",
                    practice_time: "Tuesday,Thursday",
                    practice_location: "Underhill,Hass",
                    locked: false,
                    maximum_picks: 100)
    result = team.concat_time_and_loc
    assert result[0] == ["Tuesday", "Underhill"]
    assert result[1] == ["Thursday", "Hass"]
  end
end
