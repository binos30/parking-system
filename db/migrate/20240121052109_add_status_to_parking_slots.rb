# frozen_string_literal: true

class AddStatusToParkingSlots < ActiveRecord::Migration[7.1]
  def change
    add_column :parking_slots, :status, :integer, default: :vacant
    add_index :parking_slots, :status

    ParkingSlot.where(status: nil).find_each { |parking_slot| parking_slot.vacant! }
  end
end
