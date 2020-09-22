class CarCategory < ApplicationRecord
  has_many :car_models
  has_many :cars, through: :car_models

  validates :name, :daily_rate, :car_insurance, 
            :third_party_insurance, presence: true
  validates :name, uniqueness: { case_sensitive: false }

  def daily_price
    daily_rate + car_insurance + third_party_insurance
  end
end
