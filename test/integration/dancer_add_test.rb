require 'test_helper'

class DancerAddTest < Capybara::Rails::TestCase
  test 'audition form submits' do
    visit "/audition"

    fill_in "Full Name", with: "Jeffrey Chen"
    fill_in "Email", with: "jeffreydchen@berkeley.edu"
    fill_in "Phone", with: "732-640-3705"
    select "Male", from: "Gender"
    select "Junior", from: "Year"
    select "No", from: "Prior Dance Experience"
    select "Yes", from: "EXP Interest"
    select "Yes", from: "AFX Tech Interest"

    click_on 'I\'m ready to audition!'
  end
end
