Feature: Accueil kilometrage

Scenario: Visitor sees homepage
  When I go to homepage
  Then I should see homepage

Scenario: Visitor see lists of rental
  Given many rentals exists
  When I go to homepage
  Then I should see list of rentals

Scenario: Visitor can upload track file
  When I go to homepage
  Then I can register new rental

Scenario: Visitor can delete
  Given many rentals exists
  When I go to homepage
  Then I can delete rental

Scenario: Visitor can delete
  Given many rentals exists
  When I go to homepage
  Then I can update rental
