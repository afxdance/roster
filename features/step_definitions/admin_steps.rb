Given(/the following (.*) exist:$/) do |type, table|
  # For example, dancers => Dancer
  klass = Object.const_get(type.singularize.camelcase)
  table.hashes.each do |element|
    klass.create!(element)
  end
end

Given(/^I am logged into the admin panel$/) do
  visit "/admin/login"
  fill_in "Email", with: "admin@example.com"
  fill_in "Password", with: "password"
  click_button "Login"
  if page.respond_to? :should
    page.should have_content("Signed in successfully.")
  else
    assert page.has_content?("Signed in successfully.")
  end
end

Given(/I log in as "(.*?)" with password "(.*?)"$/) do |username, pass|
  visit "/admin/login"
  fill_in "user[username]", with: username
  fill_in "user[password]", with: pass
  click_button "Login"
end
