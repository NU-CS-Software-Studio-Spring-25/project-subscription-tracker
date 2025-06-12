Feature: Add Subscription
  As a user
  I want to add new subscriptions
  So that I can track my recurring expenses

  Background:
    Given I am a registered user
    And I am logged in
    And the following categories exist:
      | name           |
      | Entertainment  |
      | Productivity   |

  Scenario: Add a new subscription successfully
    Given I am on the subscriptions page
    When I click "Add New Subscription"
    And I fill in the subscription form with:
      | field                      | value          |
      | Name                       | Netflix        |
      | Category                   | Entertainment  |
      | Price                      | 15.49          |
      | Billing cycle              | Monthly        |
      | Next payment date          | 2025-07-15     |
      | Notify (days before)       | 3              |
    And I click "Add Subscription"
    Then I should see "Netflix" in the subscriptions list
    And I should see "$15.49" in the subscription details

  Scenario: Cannot add subscription without required fields
    Given I am on the subscriptions page
    When I click "Add New Subscription"
    And I fill in the subscription form with:
      | field                      | value          |
      | Name                       |                |
      | Price                      |                |
    And I click "Add Subscription"
    Then I should see validation errors