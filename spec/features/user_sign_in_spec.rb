require 'rails_helper'

feature 'User sign in' do
  scenario 'from home page' do
    visit root_path

    expect(page).to have_link('Entrar')
  end
  scenario 'successfully' do
    User.create!(name: 'Luisa Landert', email: 'luisa@email.com', 
                 password: 'abc123')

    visit root_path
    click_on 'Entrar'
    fill_in 'Email', with: 'luisa@email.com'
    fill_in 'Senha', with: 'abc123'
    click_on 'Entrar'

    expect(page).to have_content('Luisa Landert')
    expect(page).to have_content('Login efetuado com sucesso')
    expect(page).to have_link('Sair')
    expect(page).not_to have_link('Entrar')
  end

  scenario 'and sign out' do
    User.create!(name: 'Luisa Landert', email: 'luisa@email.com', 
                 password: 'abc123')

    visit root_path
    click_on 'Entrar'
    fill_in 'Email', with: 'luisa@email.com'
    fill_in 'Senha', with: 'abc123'
    click_on 'Entrar'
    click_on 'Sair'

    expect(page).to have_link('Entrar')
    expect(page).to have_content('Logout efetuado com sucesso.')
    expect(page).not_to have_link('Sair')

  end
end