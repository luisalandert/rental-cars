class Rental < ApplicationRecord
  belongs_to :customer
  belongs_to :car_category
  belongs_to :user

  def total
    total_rental_days = end_date - start_date
    total_rental_days * car_category.daily_price
  end
end
