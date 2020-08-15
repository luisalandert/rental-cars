require 'rails_helper'

feature 'Admin view subsidiaries' do
  scenario 'successfully' do
    # CNPJ_one = CNPJ.generate
    # CNJP_two = CNPJ.generate
    Subsidiary.create!(name: 'Morumbi', CNPJ: '00862340434393', address: 'Av. Morumbi, 378')
    Subsidiary.create!(name: 'Jardins', CNPJ: '91208431548450',  address: 'Alameda Lorena, 654')

    visit root_path
    click_on 'Filiais'

    expect(current_path).to eq subsidiaries_path
    expect(page).to have_content('Morumbi')
    expect(page).to have_content('Jardins')
  end

  scenario 'and view details' do
    Subsidiary.create!(name: 'Morumbi', CNPJ: '00862340434393', address: 'Av. Morumbi, 378')
    Subsidiary.create!(name: 'Jardins', CNPJ: '91208431548450',  address: 'Alameda Lorena, 654')

    visit root_path
    click_on 'Filiais'
    click_on 'Morumbi'

    expect(page).to have_content('Morumbi')
    expect(page).to have_content('00862340434393')
    expect(page).to have_content('Av. Morumbi, 378')
    expect(page).not_to have_content('Jardins')
  end
end