require "test_helper"

class DancerTest < ActiveSupport::TestCase
  test "dancers added" do
    assert_equal 4, Dancer.count
  end

  test "Howard's phone number" do
    assert_equal "999-999-9999", dancers(:howard).phone
  end

  test "Howard's year" do
    assert_equal "sophomore", dancers(:howard).year
  end

  test "Howard's dance exp" do
    assert_equal "some", dancers(:howard).dance_experience
  end

  test "are there 4 dancers added" do
    assert_equal 4, Dancer.count
  end

  test "young's gender" do
    assert_equal "male", dancers(:young).gender
  end

  test "young's email" do
    assert_equal "youngcai@berkeley.edu", dancers(:young).email
  end

  test "Jeffrey's experience" do
    assert_equal "two", dancers(:jeffrey).dance_experience
  end

  test "Jeffrey's email" do
    assert_equal "jeffreydchen@berkeley.edu", dancers(:jeffrey).email
  end

  test "Jeffrey's phone" do
    assert_equal "732-640-3705", dancers(:jeffrey).phone
  end

  test "Patricia's phone number" do
    assert_equal "510-505-4813", dancers(:patricia).phone
  end

  test "Patricia's email" do
    email = "patriciayu7@berkeley.edu"
    assert_equal email, dancers(:patricia).email
  end

  test "Patricia's experience" do
    # should fail
    assert_equal "some", dancers(:patricia).dance_experience
  end
end
