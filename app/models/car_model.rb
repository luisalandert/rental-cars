class CarModel < ApplicationRecord
  belongs_to :car_category
  validates :name, :year, :manufacturer, :fuel_type,
            :motorization, presence: true
end
