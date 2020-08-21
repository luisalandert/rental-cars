require 'rails_helper'

feature 'Admin register car model' do
  scenario 'successfully' do
    CarCategory.create!(name: 'Top', daily_rate: 100,
                        car_insurance: 50, third_party_insurance: 50)
    
    visit root_path
    click_on 'Modelos de carro'
    click_on 'Registrar um modelo de carro'

    fill_in 'Nome', with: 'Ka' 
    fill_in 'Ano', with: '2019' 
    fill_in 'Fabricante', with: 'Ford'
    fill_in 'Motorização', with: '1.0' 
    select 'Top', from: 'Categoria de carro'
    fill_in 'Tipo de combustível', with: 'Flex' 
    click_on 'Enviar'

    expect(page).to have_content('Ka')
    expect(page).to have_content('2019')
    expect(page).to have_content('Ford')
    expect(page).to have_content('1.0')
    expect(page).to have_content('Top')
    expect(page).to have_content('Flex')

  end

  scenario 'must fill in all fields' do
    visit root_path
    click_on 'Modelos de carro'
    click_on 'Registrar um modelo de carro'
    click_on 'Enviar'

    expect(page).to have_content('Nome não pode ficar em branco')
    expect(page).to have_content('Ano não pode ficar em branco')
    expect(page).to have_content('Fabricante não pode ficar em branco')
    expect(page).to have_content('Motorização não pode ficar em branco')
    expect(page).to have_content('Categoria de carro é obrigatório(a)')
    expect(page).to have_content('Tipo de combustível não pode ficar em branco')

  end
end