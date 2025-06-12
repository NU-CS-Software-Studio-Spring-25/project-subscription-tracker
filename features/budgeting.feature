Feature: Budgeting
  As a user
  I want to set and manage budgets for subscription categories
  So that I can control my spending

  Background:
    Given I am a registered user
    And I am logged in
    And the following categories exist:
      | name           |
      | Entertainment  |
      | Productivity   |
    And I have the following subscriptions:
      | name      | category      | price | billing_cycle |
      | Netflix   | Entertainment | 15.49 | Monthly       |
      | Spotify   | Entertainment | 9.99  | Monthly       |

  Scenario: Set a monthly budget for a category
    Given I am on the budgeting page
    When I set a monthly budget of "50.00" for "Entertainment"
    Then I should see "Monthly budget updated successfully!"
    And I should see "$25.48 / $50.00" for Entertainment

  Scenario: Cannot set zero or negative budget
    Given I am on the budgeting page
    When I try to set a budget of "0" for "Entertainment"
    Then I should see "Budget amount must be greater than 0."
    And no budget should be set for Entertainment