# frozen_string_literal: true

class CreateParkingLots < ActiveRecord::Migration[7.1]
  def change
    create_table :parking_lots do |t|
      t.string :name, null: false

      t.timestamps
    end
    add_index :parking_lots, :name, unique: true
  end
end
