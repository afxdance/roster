Feature: Are Buttons Hidden Based on User Type?
  As a director
  When I navigate to admin page
  I should not be able to see all the buttons to restricted pages

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
     |director    | password  |

  Scenario: Director should not be able to see the Dancers, Team Switch Request, and Users buttons
    Given I log in as "director" with password "password"
    Then I should not see the Team Switch Request and Users buttons

  Scenario: Admin should be able to see everything
    Given I log in as "admin" with password "password"
    Then I should see all buttons
