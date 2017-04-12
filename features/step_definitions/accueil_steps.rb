When(/^I go to homepage$/) do
  visit root_path
end

Then(/^I should see homepage$/) do
  expect(page).to have_content("Rental Name")
end

Given(/^many rentals exists$/) do
  @rental = Rental.new(name: 'Rental Paris')
  @rental.save

  @caen_rental = Rental.new(name: 'tesla voyage s3')
  @caen_rental.save

  expect(Rental.all.size).to eq 2
end


Then(/^I should see list of rentals$/) do
  expect(page).to have_content("Rentals list")
  expect(page).to have_content('Paris')
  expect(page).to have_content('tesla')
end


Then(/^I can register new rental$/) do
  click_link "New Rental"
  expect(page).to have_content("New Rental")
  fill_in "rental[name]", with: "Renault X2"
  click_button("Create Rental")
  rental = Rental.find_by_name('Renault X2')
  expect(page).to have_current_path(rental_path(rental))
  expect(page).to have_content('Renault')
end

Then(/^I can delete rental$/) do
  first("#rental-#{@rental.id}").click_link "Destroy"
  expect(page).to have_current_path(root_path)
  expect(page).to have_no_content("Rental Paris")
end

Then(/^I can update rental$/) do
  first("#rental-#{@rental.id}").click_link "Edit"
  fill_in "rental[name]", with: "PSA Peugeot"
  click_button("Update Rental")
  expect(page).to have_content("Peugeot")
end
