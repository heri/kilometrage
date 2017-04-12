Given(/^rental exists$/) do
  @rental = Rental.new(name: 'Peugeot')
  @rental.save
  expect(Rental.all.size).to eq 1
  visit root_path
  click_link "Peugeot"
  expect(page).to have_current_path(rental_path(@rental))
end

When(/^I add an empty csv$/) do
  click_link "Add Track"
  expect(page).to have_current_path(new_rental_track_path(@rental))
  attach_file "track[recording]", "features/asset_specs/empty.csv"
  click_button "Create Track"
end

Then(/^I get 0 mileage$/) do
  expect(page).to have_current_path(rental_path(@rental))
  expect(page).to have_content("Total 0.0km")
end

Then(/^I get error$/) do
  expect(page).to have_content("Recording content type is invalid")
end

When(/^I add a stationary file$/) do
  click_link "Add Track"
  expect(page).to have_current_path(new_rental_track_path(@rental))
  attach_file "track[recording]", "features/asset_specs/stationary.csv"
  click_button "Create Track"
end

When(/^I add a long track$/) do
  click_link "Add Track"
  expect(page).to have_current_path(new_rental_track_path(@rental))
  attach_file "track[recording]", "features/asset_specs/concorde_grande_armee_2km.csv"
  click_button "Create Track"
end

Then(/^I get a correct long linear mileage$/) do
  expect(page).to have_current_path(rental_path(@rental))
  expect(page).to have_content("concorde_grande_armee_2km.csv Total 1.9")
end

When(/^I add a reverse track$/) do
  click_link "Add Track"
  expect(page).to have_current_path(new_rental_track_path(@rental))
  attach_file "track[recording]", "features/asset_specs/reverse_concorde_grande_armee_via_friedland_2.7km.csv"
  click_button "Create Track"
end

Then(/^I get a correct reverse mileage$/) do
  expect(page).to have_current_path(rental_path(@rental))
  expect(page).to have_content("reverse_concorde_grande_armee_via_friedland_2.7km.csv Total ")
end


When(/^I add urban erratic distances$/) do
  click_link "Add Track"
  expect(page).to have_current_path(new_rental_track_path(@rental))
  attach_file "track[recording]", "features/asset_specs/zizag_paris_4.4km.csv"
  click_button "Create Track"
end

Then(/^I get a correct urban mileage$/) do
  expect(page).to have_current_path(rental_path(@rental))
  expect(page).to have_content("zizag_paris_4.4km.csv Total 4")
end

When(/^I add a circular track$/) do
  click_link "Add Track"
  expect(page).to have_current_path(new_rental_track_path(@rental))
  attach_file "track[recording]", "features/asset_specs/tour_de_paris.csv"
  click_button "Create Track"
end

Then(/^I get a correct circular mileage$/) do
  expect(page).to have_current_path(rental_path(@rental))
  expect(page).to have_content("tour_de_paris.csv Total 31")
end

When(/^I add a heavy file$/) do
  click_link "Add Track"
  expect(page).to have_current_path(new_rental_track_path(@rental))
  attach_file "track[recording]", "features/asset_specs/csv_1.csv"
  click_button "Create Track"
end

Then(/^I get a correct heavy mileage$/) do
  expect(page).to have_current_path(rental_path(@rental))
  expect(page).to have_content("csv_1.csv Total 2145")
end
