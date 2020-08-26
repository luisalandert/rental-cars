require 'rails_helper'

feature 'Admin schedule rental' do
  scenario 'must be signed in to schedule rental' do
    visit new_rental_path

    expect(current_path).to eq new_user_session_path
  end

  scenario 'successfully' do
    CarCategory.create!(name: 'A', car_insurance: 100, daily_rate: 100,
                        third_party_insurance: 100)
    Customer.create!(name: 'João da Silva', cpf: '515.416.573-06',
                     email: 'teste@cliente.com')
    user = User.create!(name: 'Maria Aparecida', email: 'teste@user.com',
                        password: '12345678')
          
    login_as(user, scope: :user)
    visit root_path
    click_on 'Locações'
    click_on 'Agendar nova locação'
    fill_in 'Data de início', with: '21/08/2030'
    fill_in 'Data de término', with: '23/08/2030'
    select 'João da Silva - 515.416.573-06', from: 'Cliente'
    select 'A', from: 'Categoria de carro'
    click_on 'Agendar'
          
    expect(page).to have_content('21/08/2030')
    expect(page).to have_content('23/08/2030')
    expect(page).to have_content('A')
    expect(page).to have_content('R$ 600,00')
    expect(page).to have_content('João da Silva')
    expect(page).to have_content('515.416.573-06')
    expect(page).to have_content('teste@cliente.com')
    expect(page).to have_content('Agendamento realizado com sucesso')
  end
        
  scenario 'must fill in all fields' do
    user = User.create!(name: 'Maria Aparecida', email: 'teste@user.com',
                        password: '12345678')
                
    login_as(user, scope: :user)
    visit root_path
    click_on 'Locações'
    click_on 'Agendar nova locação'
    click_on 'Agendar'

    expect(page).to have_content('Data de início não pode ficar em branco')
    expect(page).to have_content('Data de término não pode ficar em branco')
    expect(page).to have_content('Categoria de carro é obrigatório(a)')
    expect(page).to have_content('Cliente é obrigatório(a)')
  end
end