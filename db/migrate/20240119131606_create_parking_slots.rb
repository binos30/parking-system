class CreateParkingSlots < ActiveRecord::Migration[7.1]
  def change
    create_table :parking_slots do |t|
      t.integer :slot_type, null: false
      t.string :distances, null: false
      t.references :parking_lot, null: false, foreign_key: true

      t.timestamps
    end
    add_index :parking_slots, :slot_type
    add_index :parking_slots, :distances
  end
end
