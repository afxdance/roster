Feature: Working Admin Page
  As an admin
  So that I can navigate the site
  I want to be able to view the admin page

  Background: the admin page has some content
    Given I am on the Admin Login Page
    #  Given the following dancers exist:
    #     | name     | year    | gender | email           | phone        |
    #     | Dancer1  | 4       | Male      | test@test.com   | 999-999-9999 |
    Given the following teams exist:
      | name | project |
      | Hi   | false   |

    Given the following admins exist:
      | email             | password | password_confirmation | admin_type |
      | admin             | password | password              | admin      |

    Then I log in as "admin" with password "password"
    And I should see "Signed in successfully."


  Scenario: I should be able to log in successfully as an Admin
    Given I log in as "admin" with password "password"
    Then I should be on the Admin Page
    And I should see "Signed in successfully."
