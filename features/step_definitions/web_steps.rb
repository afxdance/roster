module WithinHelpers
  def with_scope(locator)
    locator ? within(*selector_for(locator)) { yield } : yield
  end
end
World(WithinHelpers)

Then(/^I follow the view with number "(.*?)"$/) do |arg1|
  find(:xpath, "//a[@href=\"/admin/dancers/#{arg1}\"]").click
end

Then(/^I follow the add view with number (\d+)$/) do |arg1|
  find(:xpath, "//a[@href=\"/admin/dancers/#{arg1}/add_to_my_team\"]").click
end

Then(/^I follow the team view with number (\d+)$/) do |arg1|
  find(:xpath, "//a[@href=\"/admin/teams/#{arg1}\"]").click
end

Then(/^I should get a download with the filename "([^\"]*)"$/) do |filename|
  page.response_headers["Content-Disposition"].should include("filename=#{filename}")
end

# Then /^I am leading the team "([^\"]*)"$/ do |name|
#	User.team == name
# end

When(/^(?:|I )go to (.+)$/) do |page_name|
  visit path_to(page_name)
end

When(/^(?:|I )press "([^"]*)"$/) do |button|
  click_button(button)
end

When(/^(?:|I )follow "([^"]*)"$/) do |link|
  click_link(link)
end

# When /^(?:|I )follow2 "([^"]*)"$/ do |link|
#  click_link(link)
#  save_and_open_page
# end

When(/^(?:|I )select "([^"]*)" from "([^"]*)"$/) do |value, field|
  select value, from: field
end

When(/^(?:|I )fill in "([^"]*)" with "([^"]*)"$/) do |field, value|
  fill_in(field, with: value)
end

Then(/^(?:|I )should see "([^"]*)"$/) do |text|
  if page.respond_to? :should
    page.should have_content(text)
  else
    assert page.has_content?(text)
  end
end

Then(/^I should see all dancers on teams$/) do
  has_team = true
  Dancer.all.each do |dancer|
    if dancer.teams.zero?
      has_team = false
    end
  end
  has_team
end

Then(%r{/^(?:|I )should see \/([^\/]*)\/$/}) do |regexp|
  regexp = Regexp.new(regexp)

  if page.respond_to? :should
    page.should have_xpath("//*", text: regexp)
  else
    assert page.has_xpath?("//*", text: regexp)
  end
end

Then(/^I should not see "(.*?)"$/) do |regexp|
  regexp = Regexp.new(regexp)

  if page.respond_to? :should
    page.should have_no_xpath("//*", text: regexp)
  else
    assert page.has_no_xpath?("//*", text: regexp)
  end
end

Then(/^(?:|I )should be on (.+)$/) do |page_name|
  current_path = URI.parse(current_url).path
  if current_path.respond_to? :should
    current_path.should == path_to(page_name)
  else
    assert_equal path_to(page_name), current_path
  end
end

When(/^(?:|I )check "([^"]*)"$/) do |field|
  check(field)
end

When(/^(?:|I )check2 "([^"]*)"$/) do |field|
  check("batch_action_item_#{field}")
end

# When "I follow the view link for "$name"" do |name|
#  with_scope("/tr[td[text() = "#{name}"]]") { click_link "View" }
# end

# When /^(?:|I )check the checkbox with id "([^"]*)"$/ do |field|
#  find(:xpath, %{//[@id="batch_action_item_#{field}"]}).set(true)
# end

# When /^(?:|I )check2 "([^"]*)"$/ do |field|
#  check("batch_action_item_#{field}")
# end

When(/^(?:|I )follow "([^"]*)" for team "([^"]*)"$/) do |link, team|
  page.find_by_id(team.to_s).click_link(link)
end

Then(/^(?:|I )follow "([^"]*)" for dancer "([^"]*)"$/) do |link, dancer|
  page.find_by_id(dancer.to_s).click_link(link)
end

When(/^(?:|I )select a dancer "([^"]*)"$/) do |dancer|
  page.find("td", text: dancer.to_s).click
end
