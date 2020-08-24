require 'rails_helper'

feature 'Admin view subsidiaries' do
  scenario 'must be signed in' do
    visit root_path
    click_on 'Filiais'

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content('Para continuar, faça login ou registre-se.')
  end

  scenario 'must be signed in to access details' do
    morumbi = Subsidiary.create!(name: 'Morumbi', CNPJ: '00862340434393', address: 'Av. Morumbi, 378')

    visit subsidiary_path(morumbi)

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content('Para continuar, faça login ou registre-se.')
  end

  scenario 'successfully' do
    # CNPJ_one = CNPJ.generate
    # CNJP_two = CNPJ.generate
    Subsidiary.create!(name: 'Morumbi', CNPJ: '00862340434393', address: 'Av. Morumbi, 378')
    Subsidiary.create!(name: 'Jardins', CNPJ: '91208431548450',  address: 'Alameda Lorena, 654')
    user = User.create!(name: 'Luisa Landert', email: 'luisa@email.com', 
                        password: 'abc123')

    login_as(user, scope: :user)
    visit root_path
    click_on 'Filiais'

    expect(current_path).to eq subsidiaries_path
    expect(page).to have_content('Morumbi')
    expect(page).to have_content('Jardins')
  end

  scenario 'and view details' do
    Subsidiary.create!(name: 'Morumbi', CNPJ: '00862340434393', address: 'Av. Morumbi, 378')
    Subsidiary.create!(name: 'Jardins', CNPJ: '91208431548450',  address: 'Alameda Lorena, 654')
    user = User.create!(name: 'Luisa Landert', email: 'luisa@email.com', 
                        password: 'abc123')

    login_as(user, scope: :user)
    visit root_path
    click_on 'Filiais'
    click_on 'Morumbi'

    expect(page).to have_content('Morumbi')
    expect(page).to have_content('00862340434393')
    expect(page).to have_content('Av. Morumbi, 378')
    expect(page).not_to have_content('Jardins')
  end
end