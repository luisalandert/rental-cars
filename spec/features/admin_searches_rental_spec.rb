require 'rails_helper'

feature 'Admin searches rental' do
  scenario 'and finds exact match' do
    car_category = CarCategory.create!(name: 'A', car_insurance: 100, daily_rate: 100,
                                       third_party_insurance: 100)
    customer = Customer.create!(name: 'João da Silva', cpf: '515.416.573-06',
                                email: 'teste@cliente.com')
    user = User.create!(name: 'Maria Aparecida', email: 'teste@user.com',
                        password: '12345678')
    rental = Rental.create!(start_date: Date.current, end_date: 1.day.from_now,
                            customer: customer, car_category: car_category, user: user)
    another_rental = Rental.create!(start_date: Date.current, end_date: 1.day.from_now,
                                    customer: customer, car_category: car_category, user: user)

    login_as user, scope: :user
    visit root_path
    click_on 'Locações'
    fill_in 'Busca de locação', with: rental.token
    click_on 'Buscar'

    expect(page).to have_content(rental.token)
    expect(page).not_to have_content(another_rental.token)
    expect(page).to have_content(rental.customer.name)
    expect(page).to have_content(rental.customer.email)
    expect(page).to have_content(rental.customer.cpf)
    expect(page).to have_content(rental.user.email)
    expect(page).to have_content(rental.car_category.name)
  end
  
  xscenario 'and finds nothing' do
  end

  scenario 'and finds partial token' do
    car_category = CarCategory.create!(name: 'A', car_insurance: 100, daily_rate: 100,
                                       third_party_insurance: 100)
    customer = Customer.create!(name: 'João da Silva', cpf: '515.416.573-06',
                                email: 'teste@cliente.com')
    user = User.create!(name: 'Maria Aparecida', email: 'teste@user.com',
                        password: '12345678')
    rental = Rental.create!(start_date: Date.current, end_date: 1.day.from_now,
                            customer: customer, car_category: car_category, user: user)
    rental.update(token: 'ABC123')
    another_rental = Rental.create!(start_date: Date.current, end_date: 1.day.from_now,
                                    customer: customer, car_category: car_category, user: user)
    another_rental.update(token: 'ABC567')
    rental_not_to_be_found = Rental.create!(start_date: Date.current, end_date: 1.day.from_now,
                                            customer: customer, car_category: car_category, user: user)
    rental_not_to_be_found.update(token: '890988')

    login_as user, scope: :user
    visit root_path
    click_on 'Locações'
    fill_in 'Busca de locação', with: 'ABC'
    click_on 'Buscar'

    expect(page).to have_content(rental.token)
    expect(page).to have_content(another_rental.token)
    expect(page).not_to have_content(rental_not_to_be_found.token)
  end

end