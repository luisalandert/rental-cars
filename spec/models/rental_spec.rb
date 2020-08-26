require 'rails_helper'

RSpec.describe Rental, type: :model do
  context 'token' do
    it 'generate on create' do
      car_category = CarCategory.create!(name: 'A', car_insurance: 100, daily_rate: 100,
                          third_party_insurance: 100)
      customer = Customer.create!(name: 'João da Silva', cpf: '515.416.573-06',
                       email: 'teste@cliente.com')
      user = User.create!(name: 'Maria Aparecida', email: 'teste@user.com',
                          password: '12345678')
      rental = Rental.new(start_date: Date.current, end_date: 1.day.from_now,
                              customer: customer, car_category: car_category, user: user)

      rental.save!

      expect(rental.token).to be_present
      expect(rental.token.size).to eq(6)
      expect(rental.token).to match(/^[A-Z0-9]+$/)
    end

    xit 'must be unique' do
    end
  end
  
end
