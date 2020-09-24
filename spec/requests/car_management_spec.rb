describe 'Car management' do
  context 'index' do
    it 'renders available cars' do
      car_model = create(:car_model)
      subsidiary = create(:subsidiary)
      create(:car, license_plate: 'ABC1234', color: 'Vermelho',
                   car_model: car_model, subsidiary: subsidiary, status: :available)
      create(:car, license_plate: 'DCF4356', color: 'Preto',
                   car_model: car_model, subsidiary: subsidiary, status: :available)
      create(:car, license_plate: 'FDSE1234', color: 'Preto',
                    car_model: car_model, subsidiary: subsidiary, status: :rented)

      get '/api/v1/cars'

      expect(response).to have_http_status(200)
      body = JSON.parse(response.body, symbolize_names: true)
      expect(body[0][:license_plate]).to eq('ABC1234')
      expect(body[0][:color]).to eq('Vermelho')
      expect(body[1][:license_plate]).to eq('DCF4356')
      expect(response.body).not_to include('FDSE1234')
    end
  end
end