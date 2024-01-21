# frozen_string_literal: true

class Booking < ApplicationRecord
  attr_accessor :entrance_id

  enum vehicle_type: { small: 0, medium: 1, large: 2 }

  belongs_to :parking_slot

  validates :vehicle_type, presence: true, inclusion: { in: vehicle_types.keys }
  validates :plate_number, presence: true, length: { minimum: 2, maximum: 9 }

  def plate_number=(value)
    self[:plate_number] = value.upcase
  end
end
