Feature: New Report
  In order to track found tags
  As a user
  I want to be able to request submit a report

  Background:
    Given an admin user exists
    And an approved investigator exists
    And a study exists with user: that user
    And a tag exists with code: "ABC123", study: that study
    And a tag_deployment exists with tag: that tag
    And I am not logged in
    And no emails have been sent
    And I am on the home page
    And I go to the report a tag page

  Scenario: User fills in valid data
    Given I fill in a valid report
    And I press "Create Report"
    Then I should see "Thank you for submitting a Report!"
    And a report should exist with tag_deployment: that tag_deployment
    And "report_submitted@glatos.org" should receive 1 email
    When I open the email
    Then I should see "Thank you for your Report!" in the email body
    And I should see "ABC123" in the email body

  Scenario: Admin should get an email when a valid Report is submitted and the tag is not matched
    Given I fill in a valid report
    And I fill in "ID Tag Number" with "NOT-ABC123"
    And I press "Create Report"
    Then "investigator@glatos.org" should receive 0 emails
    And "admin@test.com" should receive 1 email
    When I open the email
    Then I should see "A report was filed that did not match any known tags" in the email body
    And I should see "ABC123" in the email body

  Scenario: Investigator should get an email when a valid Report is submitted and the tag is matched
    Given I fill in a valid report
    And I press "Create Report"
    Then "admin@test.com" should receive 0 emails
    And "investigator@glatos.org" should receive 1 email
    When I open the email
    Then I should see "A tag was found that was linked to your project" in the email body
    And I should see "ABC123" in the email body