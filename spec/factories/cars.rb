FactoryBot.define do
  factory :car do
    license_plate { 'ABC1234' }
    color  { 'Branco' }
    mileage {0}
    status {:available}
    car_model
    subsidiary
  end
end