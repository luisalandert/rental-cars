class CarModel < ApplicationRecord
  belongs_to :car_category
  has_many :cars

  validates :name, :year, :manufacturer, :fuel_type,
            :motorization, presence: true
end
