class CreateBookings < ActiveRecord::Migration[7.1]
  def change
    create_table :bookings do |t|
      t.references :parking_slot, null: false, foreign_key: true
      t.integer :vehicle_type, null: false
      t.string :plate_number, null: false
      t.datetime :date_park
      t.datetime :date_unpark
      t.decimal :fee, precision: 8, scale: 2, null: false, default: 0

      t.timestamps
    end
    add_index :bookings, :vehicle_type
    add_index :bookings, :plate_number
  end
end
