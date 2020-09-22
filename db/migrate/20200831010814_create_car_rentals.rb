class CreateCarRentals < ActiveRecord::Migration[6.0]
  def change
    create_table :car_rentals do |t|
      t.references :rental, null: false, foreign_key: true
      t.references :car, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.datetime :start_date
      t.string :driver_license_number

      t.timestamps
    end
  end
end
