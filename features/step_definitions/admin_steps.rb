Given(/the following (.*) exist:$/) do |type, table|
  table.hashes.each do |element|
    if type == "dancers" then Dancer.create!(element)
    end
    if type == "admins" then AdminUser.create!(element)
    end
    if type == "casting_groups" then CastingGroup.create!(element)
    end
    if type == "teams" then Team.create(element)
    end
  end
end

Given(/^I am logged into the admin panel$/) do
  visit "/admin/login"
  fill_in "Email", with: "admin"
  fill_in "Password", with: "password"
  click_button "Login"
  if page.respond_to? :should
    page.should have_content("Signed in successfully.")
  else
    assert page.has_content?("Signed in successfully.")
  end
end

Given(/I log in as "(.*?)" with password "(.*?)"$/) do |email, pass|
  visit "/admin/login"
  fill_in "admin_user[email]", with: email
  fill_in "admin_user[password]", with: pass
  click_button "Login"
end

Given(/^(?:|I )am on (.+)$/) do |page_name|
  visit path_to(page_name)
end

Then("I should see {string}") do |string|
  pending # Write code here that turns the phrase above into concrete actions
end

Then("I should be on the Admin Page") do
  pending # Write code here that turns the phrase above into concrete actions
end
