require 'rails_helper'

RSpec.describe Car, type: :model do
  describe '.description' do
    it 'should return car model name, color and license plate' do
      subsidiary = Subsidiary.create!(name: 'Morumbi', CNPJ: '00862340434393',
                                      address: 'Av. Morumbi, 378')
      car_category = CarCategory.create!(name: 'A', car_insurance: 100, daily_rate: 100,
                                         third_party_insurance: 100)
      car_model = CarModel.create!(name: 'Fox', year: 2019, manufacturer: 'Volkswagen', 
                                   motorization: '1.4', car_category: car_category, fuel_type: 'Flex')
      car = Car.new(license_plate: 'ABC123', color: 'Prata', car_model: car_model,
                        mileage: 0, subsidiary: subsidiary)

      result = car.description()
      
      expect(result).to eq 'Fox - Prata - ABC123'

    end
  end 
end
