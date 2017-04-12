Feature: Calculs Kilometrage

Scenario: Visitor gets 0 mileage for empty
  Given rental exists
  When I add an empty csv
  Then I get error

Scenario: Visitor gets 0 mileage for stationary
  Given rental exists
  When I add a stationary file
  Then I get 0 mileage

Scenario: Visitor gets correct mileage for long linear track
  Given rental exists
  When I add a long track
  Then I get a correct long linear mileage

Scenario: Visitor gets correct mileage for long linear track reversed
  Given rental exists
  When I add a reverse track
  Then I get a correct reverse mileage

Scenario: Visitor gets correct mileage for urban distances
  Given rental exists
  When I add urban erratic distances
  Then I get a correct urban mileage

Scenario: Visitor gets correct mileage for circular track
  Given rental exists
  When I add a circular track
  Then I get a correct circular mileage

Scenario: Visitor gets correct mileage for heavy file
  Given rental exists
  When I add a heavy file
  Then I get a correct heavy mileage
