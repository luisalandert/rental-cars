include ActiveSupport::Testing::TimeHelpers

feature 'User start rental' do
  scenario 'view only category cars' do
    subsidiary = Subsidiary.create!(name: 'Morumbi', CNPJ: '00862340434393',
                                    address: 'Av. Morumbi, 378')
    user = User.create!(name: 'Maria Aparecida', email: 'teste@user.com',
                                  password: '12345678')
    customer = Customer.create!(name: 'João da Silva', cpf: '515.416.573-06',
                                email: 'teste@cliente.com')
    car_category_a = CarCategory.create!(name: 'A', car_insurance: 100, daily_rate: 100,
                                       third_party_insurance: 100)
    car_category_esp = CarCategory.create!(name: 'Especial', car_insurance: 200, daily_rate: 500,
                                       third_party_insurance: 100)
    car_model_fox = CarModel.create!(name: 'Fox', year: 2019, manufacturer: 'Volkswagen', 
                                 motorization: '1.4', car_category: car_category_a, fuel_type: 'Flex')
    car_model_fusion = CarModel.create!(name: 'Fusion', year: 2019, manufacturer: 'Ford', 
    motorization: '2.0', car_category: car_category_esp, fuel_type: 'Gasolina')
    car_fox = Car.create!(license_plate: 'ABC123', color: 'Prata', car_model: car_model_fox,
                      mileage: 0, subsidiary: subsidiary)
    car_fusion = Car.create!(license_plate: 'ABC456', color: 'Preta', car_model: car_model_fusion,
                      mileage: 0, subsidiary: subsidiary)
    rental = Rental.create!(start_date: Date.current, end_date: 1.day.from_now,
                            customer: customer, car_category: car_category_a, user: user)

    login_as user, scope: :user
    visit root_path
    click_on 'Locações'
    fill_in 'Busca de locação', with: rental.token
    click_on 'Buscar'
    click_on 'Ver detalhes'
    click_on 'Iniciar locação'

    expect(page).to have_content('Fox')
    expect(page).to have_content('Prata')
    expect(page).to have_content('ABC123')
    expect(page).not_to have_content('Fusion')
    expect(page).not_to have_content('Preta')
    expect(page).not_to have_content('ABC456')
  end
  scenario 'successfully' do
    subsidiary = Subsidiary.create!(name: 'Morumbi', CNPJ: '00862340434393',
                                    address: 'Av. Morumbi, 378')
    scheduled_user = User.create!(name: 'Maria Aparecida', email: 'teste@user.com',
                        password: '12345678')
    customer = Customer.create!(name: 'João da Silva', cpf: '515.416.573-06',
                                email: 'teste@cliente.com')
    car_category = CarCategory.create!(name: 'A', car_insurance: 100, daily_rate: 100,
                                       third_party_insurance: 100)
    car_model = CarModel.create!(name: 'Fox', year: 2019, manufacturer: 'Volkswagen', 
                                 motorization: '1.4', car_category: car_category, fuel_type: 'Flex')
    car = Car.create!(license_plate: 'ABC123', color: 'Prata', car_model: car_model,
                      mileage: 0, subsidiary: subsidiary, status: :available)
    rental = Rental.create!(start_date: Date.current, end_date: 1.day.from_now,
                            customer: customer, car_category: car_category, user: scheduled_user)
    user = User.create!(name: 'João Pessoa', email: 'email@user.com',
                        password: '56789123')
    
    login_as user, scope: :user
    visit root_path
    click_on 'Locações'
    fill_in 'Busca de locação', with: rental.token
    click_on 'Buscar'
    click_on 'Ver detalhes'
    click_on 'Iniciar locação'
    select "#{car_model.name} - #{car.color} - #{car.license_plate}", 
            from: 'Carros disponíveis'
    fill_in 'CNH do Condutor', with: 'RJ78986-10'
    #TODO: pegar o nome e cnh do condutor, fotos do carro
    travel_to Time.zone.local(2020, 10, 31, 12, 04, 44) do
      click_on 'Iniciar'
    end

    car.reload()

    expect(page).to have_content(car_category.name)
    expect(page).to have_content(scheduled_user.email)
    expect(page).to have_content(customer.email)
    expect(page).to have_content(customer.name)
    expect(page).to have_content(customer.cpf)

    expect(page).to have_content('Locação iniciada com sucesso')
    expect(page).to have_content(user.email)
    expect(page).to have_content(car_model.name)
    expect(page).to have_content(car.license_plate)
    expect(page).to have_content(car.color)
    expect(page).to have_content('RJ78986-10')
    expect(page).to have_content('31 de outubro de 2020, 12:04:44')
    expect(page).not_to have_link('Iniciar locação')
    expect(car).to be_rented
  end
end