require 'rails_helper'

feature 'Admin view car categories' do
  scenario 'must be signed in' do
    visit root_path
    click_on 'Categorias'

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content('Para continuar, faça login ou registre-se.')
  end

  scenario 'must be signed in to access details' do
    CarCategory.create!(name: 'Top', daily_rate: 105.5, car_insurance: 58.5,
                        third_party_insurance: 10.5)

    visit car_category_path(1)

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content('Para continuar, faça login ou registre-se.')
  end

  scenario 'successfully' do
    CarCategory.create!(name: 'Top', daily_rate: 105.5, car_insurance: 58.5,
                        third_party_insurance: 10.5)
    CarCategory.create!(name: 'Flex', daily_rate: 80, car_insurance: 8.5,
                        third_party_insurance: 8.5)
    user = User.create!(name: 'Luisa Landert', email: 'luisa@email.com', 
                        password: 'abc123')
         
    login_as(user, scope: :user)
    visit root_path
    click_on 'Categorias'

    expect(current_path).to eq car_categories_path
    expect(page).to have_content('Top')
    expect(page).to have_content('Flex')
  end

  scenario 'and view details' do
    CarCategory.create!(name: 'Top', daily_rate: 105.5, car_insurance: 58.5,
                        third_party_insurance: 10.5)
    CarCategory.create!(name: 'Flex', daily_rate: 80, car_insurance: 8.5,
                        third_party_insurance: 8.5)
    user = User.create!(name: 'Luisa Landert', email: 'luisa@email.com', 
                        password: 'abc123')
         
    login_as(user, scope: :user)
    visit root_path
    click_on 'Categorias'
    click_on 'Top'

    expect(page).to have_content('Top')
    expect(page).to have_content('R$ 105,50')
    expect(page).to have_content('R$ 58,50')
    expect(page).to have_content('R$ 10,50')
    expect(page).not_to have_content('Flex')
  end

  scenario 'and no car categories are created' do
    user = User.create!(name: 'Luisa Landert', email: 'luisa@email.com', 
                        password: 'abc123')

    login_as(user, scope: :user)
    visit root_path
    click_on 'Categorias'

    expect(page).to have_content('Nenhuma categoria cadastrada')
  end

  scenario 'and return to home page' do
    CarCategory.create!(name: 'Top', daily_rate: 105.5, car_insurance: 58.5,
                        third_party_insurance: 10.5)
    user = User.create!(name: 'Luisa Landert', email: 'luisa@email.com', 
                        password: 'abc123')
         
    login_as(user, scope: :user)
    visit root_path
    click_on 'Categorias'
    click_on 'Voltar'

    expect(current_path).to eq root_path
  end

  scenario 'and return to manufacturers page' do
    CarCategory.create!(name: 'Top', daily_rate: 105.5, car_insurance: 58.5,
                        third_party_insurance: 10.5)
    user = User.create!(name: 'Luisa Landert', email: 'luisa@email.com', 
                        password: 'abc123')
         
    login_as(user, scope: :user)
    visit root_path
    click_on 'Categorias'
    click_on 'Top'
    click_on 'Voltar'

    expect(current_path).to eq car_categories_path
  end
end
