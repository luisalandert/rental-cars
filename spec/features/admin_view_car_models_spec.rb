require 'rails_helper'

feature 'Admin view car models' do
  scenario 'and view list' do
    car_category = CarCategory.create!(name: 'Top', daily_rate: 200, car_insurance: 50, third_party_insurance: 30)
    CarModel.create!(name: 'Fox', year: 2019, manufacturer: 'Volkswagen', 
                     motorization: '1.4', car_category: car_category, fuel_type: 'Flex')
    CarModel.create!(name: 'Onix', year: 2020, manufacturer: 'Chevrolet', 
                     motorization: '1.0', car_category: car_category, fuel_type: 'Flex')

    visit root_path
    click_on 'Modelos de carros'

    expect(page).to have_content('Fox')
    expect(page).to have_content('Volkswagen')
    expect(page).to have_content('2019')
    expect(page).to have_content('Onix')
    expect(page).to have_content('Chevrolet')
    expect(page).to have_content('2020')
    expect(page).to have_content('Top', count: 2)
    expect(page).to have_link('Voltar', href: root_path)  
  end

  xscenario 'and view details' do
  end

  xscenario 'and nothing is registered' do
  end
end