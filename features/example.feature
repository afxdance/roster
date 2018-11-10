Feature: dancer
  As an admin
  So that I can navigate the site
  I want to be able to view the admin page

Background:
  Given I am on the Admin Login Page
  Given the following dancers exist:
     | name         | email                  | phone        |  gender   | year    | tech_interest     | exp_interest      | dance_experience  | camp_interest |
     | Peter Le     | peter@peter.peter      | pet-erp-eter |  peter    | 1       | not important rn  | not important rn  | na                | no            |
     | Alice Wu     | alice@alice.alice	     | ali-cea-lice	|  alice    | 1       | not important rn  | not important rn  | na                | no            |
     | Stella Wang  | stella@stella.stella	 | ste-lla-wang |  stella   | 2       | not important rn  | not important rn  | na                | no            |

  Given the following teams exist:
     | name        | practice_time  | locked  |  maximum_picks  |
     | AFX Help    | all the time   | false   |  100            |
     | AFX Oasis   | never          | false   |  50             |

  Given the following users exist:
     |username    | password  |
     |admin       | password  |

  Scenario: I should be able to log in successfully as an Admin
    Given I log in as "admin" with password "password"
    Then I should be on the Admin Page
    And I should see "Signed in successfully."
  Scenario: I should fail log in with incorrect information
    Given I log in as "admin" with password "passwordWRONG"
    Then I should be on the Admin Login Page
    And I should see "Invalid Username or password."
  # Scenario: I should be able to see Audition Form as an Admin
  #   Given I log in as "admin" with password "password"
  #   Then I should be on the Admin Page
  #   And I should see "Signed in successfully."
  #   Then I follow "Audition Form"
  #   And I should see "AFX AUDITIONS"
  #   And I fill in "dancer[name]" with "Name"
  #   And I select "Senior or older" from "dancer[year]"
  #   And I select "Male" from "dancer[gender]"
  #   And I fill in "dancer[email]" with "email@email.com"
  #   And I fill in "dancer[phone]" with "999-999-9999"
  #   Then I press "I'm ready to audition!"
  #   Then I should see "your audition number is"
  # Scenario: I should see registered dancers as an Admin
  #   Given I log in as "admin" with password "password"
  #   Then I should be on the Admin Page
  #   And I should see "Signed in successfully."
  #   Then I follow "Dancers"
  #   And I should see "Dancer1"
  #   Then I follow "View"
  #   And I should see "Dancer Details"
  #   And I should see "Gender Male"
  # Scenario: I should search dancers as an Admin
  #   Given I log in as "admin" with password "password"
  #   Then I should be on the Admin Page
  #   And I should see "Signed in successfully."
  #   Then I follow "Dancers"
  #   Then I fill in "q_name" with "Peter Le"
  #   Then I press "Filter"
  #   Then I should see "Dancer1"
  #   Then I follow "View"
  #   Then I should see "Gender Male"
  # Scenario: I search for a dancer that does not exist
  #   Given I log in as "admin" with password "password"
  #   Then I should be on the Admin Page
  #   And I should see "Signed in successfully."
  #   Then I follow "Dancers"
  #   Then I fill in "q_name" with "NOTAREALDANCER"
  #   Then I press "Filter"
  #   Then I should see "No Dancers found"
  # Scenario: As admin I should be able to make a training team
  #   Given I log in as "admin" with password "password"
  #   Then I should be on the Admin Page
  #   And I should see "Signed in successfully."
  #   Then I follow "Teams"
  #   Then I follow "New Team"
  #   Then I fill in "Name" with "Hi"
  #   Then I press "Create Team"
  #   Then I should see "Hi"
  #   Then I should see "Training Team"
  # Scenario: As admin I should be able to make a project team
  #   Given I log in as "admin" with password "password"
  #   Then I should be on the Admin Page
  #   And I should see "Signed in successfully."
  #   Then I follow "Teams"
  #   Then I follow "New Team"
  #   Then I fill in "Name" with "Bye"
  #   Then I check "team_project"
  #   Then I press "Create Team"
  #   Then I should see "Bye"
  #   Then I should see "Project Team"
  # @wip
  # Scenario: As an admin, I should be able to search through dancers on the Dancers page.
