require 'rails_helper'

feature 'Admin view car models' do
  scenario 'must be signed in' do
    visit root_path
    click_on 'Modelos de carro'

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content('Para continuar, faça login ou registre-se.')
  end

  scenario 'must be signed in to access show' do
    car_category = CarCategory.create!(name: 'Top', daily_rate: 200, car_insurance: 50, third_party_insurance: 30)
    CarModel.create!(name: 'Fox', year: 2019, manufacturer: 'Volkswagen', 
                     motorization: '1.4', car_category: car_category, fuel_type: 'Flex')

    visit car_model_path(1)

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content('Para continuar, faça login ou registre-se.')
  end

  scenario 'and view list' do
    car_category = CarCategory.create!(name: 'Top', daily_rate: 200, car_insurance: 50, third_party_insurance: 30)
    CarModel.create!(name: 'Fox', year: 2019, manufacturer: 'Volkswagen', 
                     motorization: '1.4', car_category: car_category, fuel_type: 'Flex')
    CarModel.create!(name: 'Onix', year: 2020, manufacturer: 'Chevrolet', 
                     motorization: '1.0', car_category: car_category, fuel_type: 'Flex')
    user = User.create!(name: 'Luisa Landert', email: 'luisa@email.com', 
                        password: 'abc123')
     
    login_as(user, scope: :user)
    visit root_path
    click_on 'Modelos de carro'

    expect(page).to have_content('Fox')
    expect(page).to have_content('Volkswagen')
    expect(page).to have_content('2019')
    expect(page).to have_content('Onix')
    expect(page).to have_content('Chevrolet')
    expect(page).to have_content('2020')
    expect(page).to have_content('Top', count: 2)
    expect(page).to have_link('Voltar', href: root_path)  
  end

  scenario 'and view details' do
    car_category = CarCategory.create!(name: 'Top', daily_rate: 200, car_insurance: 50, third_party_insurance: 30)
    CarModel.create!(name: 'Fox', year: 2019, manufacturer: 'Volkswagen', 
                     motorization: '1.4', car_category: car_category, fuel_type: 'Flex')
    CarModel.create!(name: 'Onix', year: 2020, manufacturer: 'Chevrolet', 
                     motorization: '1.0', car_category: car_category, fuel_type: 'Flex')
    user = User.create!(name: 'Luisa Landert', email: 'luisa@email.com', 
                        password: 'abc123')
     
    login_as(user, scope: :user)
    visit car_models_path
    click_on 'Fox - 2019'

    expect(page).to have_content('Fox')
    expect(page).to have_content('2019')
    expect(page).to have_content('Volkswagen')
    expect(page).to have_content('1.4')
    expect(page).to have_content('Top')
    expect(page).to have_content('Flex')
    expect(page).not_to have_content('Onix')
    expect(page).not_to have_content('Chevrolet')

  end
  
  scenario 'and view car category details from model page' do
    car_category = CarCategory.create!(name: 'Top', daily_rate: 200, car_insurance: 50, third_party_insurance: 30)
    CarModel.create!(name: 'Fox', year: 2019, manufacturer: 'Volkswagen', 
                     motorization: '1.4', car_category: car_category, fuel_type: 'Flex')
    user = User.create!(name: 'Luisa Landert', email: 'luisa@email.com', 
                        password: 'abc123')
     
    login_as(user, scope: :user)
    visit car_models_path
    click_on 'Fox'
    click_on 'Top'

    # expect(current_path).to eq car_categories_path(car_category)
    expect(page).to have_content('200') 
  end

  scenario 'and view car category details from model index page' do
    car_category = CarCategory.create!(name: 'Top', daily_rate: 200, car_insurance: 50, third_party_insurance: 30)
    CarModel.create!(name: 'Fox', year: 2019, manufacturer: 'Volkswagen', 
                     motorization: '1.4', car_category: car_category, fuel_type: 'Flex')
    user = User.create!(name: 'Luisa Landert', email: 'luisa@email.com', 
                        password: 'abc123')
     
    login_as(user, scope: :user)
    visit car_models_path
    click_on 'Top'

    # expect(current_path).to eq car_categories_path(car_category.id)
    expect(page).to have_content('200') 
  end

  scenario 'and nothing is registered' do
    user = User.create!(name: 'Luisa Landert', email: 'luisa@email.com', 
                        password: 'abc123')

    login_as(user, scope: :user)
    visit root_path
    click_on 'Modelos de carro'

    expect(page).to have_content('Nenhum modelo cadastrado')
  end
end