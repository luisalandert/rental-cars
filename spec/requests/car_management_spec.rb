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
    it 'renders empty json' do
      get api_v1_cars_path

      response_json = JSON.parse(response.body)
      expect(response).to be_ok
      expect(response.content_type).to include('application/json')
      expect(response_json).to be_empty
    end
  end
  context 'GET api/v1/car/:id' do
    context 'record exists' do
      let(:car) do
        create(:car, license_plate: 'ABC1234', color: 'Vermelho',
                      status: :available)
      end
      it 'returns 200 status' do
        get "/api/v1/cars/#{car.id}"

        expect(response).to be_ok
      end
      it 'returns car' do
        get "/api/v1/cars/#{car.id}"
        # get api_v1_car_path(car)

        response_json = JSON.parse(response.body, symbolize_names: true)
        expect(response_json[:license_plate]).to eq(car.license_plate)
        expect(response_json[:color]).to eq(car.color)
        expect(response_json[:car_model_id]).to eq(car.car_model_id)
      end
    end
    context 'record does not exist' do
      it 'return status 404' do
        get '/api/v1/cars/000'

        expect(response).to have_http_status(404)
      end
      it 'returns not found message' do
        get '/api/v1/cars/000'

        expect(response.body).to include('Carro não encontrado')
      end
    end
    
  end
  context 'POST /cars' do
    context 'with valid parameters' do
      let(:car_model) { create(:car_model) }
      let(:subsidiary) { create(:subsidiary)}
      let(:attributes) { attributes_for(:car, car_model_id: car_model.id, subsidiary_id: subsidiary.id ) }
      
      it 'return status 201' do
        post '/api/v1/cars', params: {car: attributes}

        expect(response).to have_http_status(201)
      end

      it 'creates a car' do
        post '/api/v1/cars', params: { car: attributes }

        car = JSON.parse(response.body, symbolize_names: true)
        expect(car[:id]).to be_present
        expect(car[:license_plate]).to eq(attributes[:license_plate])
        expect(car[:color]).to eq(attributes[:color])
        expect(car[:car_model_id]).to eq(attributes[:car_model_id])
      end
    end
    context 'with invalid params' do
      it 'without requested params' do
        post '/api/v1/cars', params: { car: { foo: 'bar' } }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include('Placa não pode ficar em branco')
        expect(response.body).to include('Cor não pode ficar em branco')
        expect(response.body).to include('Modelo de carro é obrigatório(a)')
        expect(response.body).to include('Filial é obrigatório(a)')
      end

      it 'without car key' do
        post '/api/v1/cars'

        expect(response).to have_http_status(:precondition_failed)
        expect(response.body).to include('Parâmetros inválidos')
      end
    end
  end
end