class Rental < ApplicationRecord
  belongs_to :customer
  belongs_to :car_category
  belongs_to :user

  before_create :generate_token

  validates :start_date, :end_date, presence: true

  def total
    total_rental_days = end_date - start_date
    total_rental_days * car_category.daily_price
  end

  private

  def generate_token
    self.token = SecureRandom.alphanumeric(6).upcase
  end
end
