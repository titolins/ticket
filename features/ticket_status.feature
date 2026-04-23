Feature: Ticket Status Management
  As a user
  I want to change ticket statuses
  So that I can track progress on tasks

  Background:
    Given a clean tickets directory
    And a ticket exists with ID "test-0001" and title "Test ticket"

  Scenario: Set status to in_progress
    When I run "ticket status test-0001 in_progress"
    Then the command should succeed
    And the output should be "Updated test-0001 -> in_progress"
    And ticket "test-0001" should have field "status" with value "in_progress"

  Scenario: Set status to closed
    When I run "ticket status test-0001 closed"
    Then the command should succeed
    And the output should be "Updated test-0001 -> closed"
    And ticket "test-0001" should have field "status" with value "closed"

  Scenario: Set status to open
    Given ticket "test-0001" has status "closed"
    When I run "ticket status test-0001 open"
    Then the command should succeed
    And the output should be "Updated test-0001 -> open"
    And ticket "test-0001" should have field "status" with value "open"

  Scenario: Start command sets status to in_progress
    When I run "ticket start test-0001"
    Then the command should succeed
    And the output should be "Updated test-0001 -> in_progress"
    And ticket "test-0001" should have field "status" with value "in_progress"

  Scenario: Close command sets status to closed
    When I run "ticket close test-0001"
    Then the command should succeed
    And the output should be "Updated test-0001 -> closed"
    And ticket "test-0001" should have field "status" with value "closed"

  Scenario: Reopen command sets status to open
    Given ticket "test-0001" has status "closed"
    When I run "ticket reopen test-0001"
    Then the command should succeed
    And the output should be "Updated test-0001 -> open"
    And ticket "test-0001" should have field "status" with value "open"

  Scenario: Invalid status value
    When I run "ticket status test-0001 invalid"
    Then the command should fail
    And the output should contain "Error: invalid status 'invalid'"
    And the output should contain "open planned in_progress closed"

  Scenario: Set status to planned
    When I run "ticket status test-0001 planned"
    Then the command should succeed
    And the output should be "Updated test-0001 -> planned"
    And ticket "test-0001" should have field "status" with value "planned"

  Scenario: Plan command sets status to planned
    When I run "ticket plan test-0001"
    Then the command should succeed
    And the output should be "Updated test-0001 -> planned"
    And ticket "test-0001" should have field "status" with value "planned"

  Scenario: Unplan command reverts status to open
    Given ticket "test-0001" has status "planned"
    When I run "ticket unplan test-0001"
    Then the command should succeed
    And the output should be "Updated test-0001 -> open"
    And ticket "test-0001" should have field "status" with value "open"

  Scenario: Start from open warns about skipping planned
    When I run "ticket start test-0001"
    Then the command should succeed
    And the output should contain "Warning: starting test-0001 from open (skipping planned)"
    And ticket "test-0001" should have field "status" with value "in_progress"

  Scenario: Start from planned is silent
    Given ticket "test-0001" has status "planned"
    When I run "ticket start test-0001"
    Then the command should succeed
    And the output should not contain "skipping planned"
    And ticket "test-0001" should have field "status" with value "in_progress"

  Scenario: Status of non-existent ticket
    When I run "ticket status nonexistent open"
    Then the command should fail
    And the output should contain "Error: ticket 'nonexistent' not found"

  Scenario: Status command with partial ID
    When I run "ticket status 0001 in_progress"
    Then the command should succeed
    And ticket "test-0001" should have field "status" with value "in_progress"
