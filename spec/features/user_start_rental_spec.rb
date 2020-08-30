feature 'User start rental' do
  scenario 'successfully' do
    car_category = CarCategory.create!(name: 'A', car_insurance: 100, daily_rate: 100,
                                       third_party_insurance: 100)
    customer = Customer.create!(name: 'João da Silva', cpf: '515.416.573-06',
                                email: 'teste@cliente.com')
    user = User.create!(name: 'Maria Aparecida', email: 'teste@user.com',
                        password: '12345678')
    rental = Rental.create!(start_date: Date.current, end_date: 1.day.from_now,
                            customer: customer, car_category: car_category, user: user)
    subsidiary = Subsidiary.create!(name: 'Morumbi', CNPJ: '00862340434393',
                                    address: 'Av. Morumbi, 378')
    car_model = CarModel.create!(name: 'Fox', year: 2019, manufacturer: 'Volkswagen', 
                           motorization: '1.4', car_category: car_category, fuel_type: 'Flex')
                 
    car = Car.create!(license_plate: 'ABC123', color: 'Prata', car_model: car_model,
                      mileage: 0)

    login_as user, scope: :user
    visit root_path
    click_on 'Locações'
    fill_in 'Busca de locação', with: rental.token
    click_on 'Buscar'
    click_on 'Ver detalhes'
    click_on 'Iniciar locação'
    select "#{car_model.name} - #{car.color} - #{car.license_plate}", 
            from: 'Carros disponíveis'
    #TODO: pegar o nome e cnh do condutor, fotos do carro
    click_on 'Iniciar'

    expect(page).to have_content('Locação iniciada com sucesso')
    expect(page).to have_content(car.license_plate)
    expect(page).to have_content(car.color)
    expect(page).to have_content(car_model.name)
    expect(page).to have_content(car_category.name)
    expect(page).to have_content(user.email)
    expect(page).to have_content(client.email)
    expect(page).to have_content(client.name)
    expect(page).to have_content(client.cpf)
  end
end