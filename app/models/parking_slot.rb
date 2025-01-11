# frozen_string_literal: true

class ParkingSlot < ApplicationRecord
  enum :slot_type, { small: 0, medium: 1, large: 2 }
  enum :status, { vacant: 0, reserved: 1, occupied: 2 }, default: :vacant

  belongs_to :parking_lot, inverse_of: :parking_slots

  has_many :bookings, inverse_of: :parking_slot, dependent: :restrict_with_exception

  validates :slot_type, inclusion: { in: slot_types.keys }
  validates :status, inclusion: { in: statuses.keys }

  validate :validate_distances

  before_validation :set_distances

  # Overwrite the setter to rely on validations instead of [ArgumentError]
  # https://github.com/rails/rails/issues/13971#issuecomment-721821257
  def slot_type=(value)
    self[:slot_type] = value
  rescue ArgumentError
    self[:slot_type] = nil
  end

  def status=(value)
    self[:status] = value
  rescue ArgumentError
    self[:status] = nil
  end

  def code
    id.to_s.rjust(3, "0")
  end

  def distances_arr
    distances.split(",")
  end

  private

  def validate_distances
    # Check if distances length/size is equal to the number of entrances
    return if distances_arr.size == Entrance.count
    errors.add(:distances, "are invalid.")
  end

  def set_distances
    # Split the distances into an array then remove whitespace
    # and convert each value to an array of integers then return to string
    # If there is not a valid number at the start of str, 0 is returned
    # (e.g. "1, , 1a, 3" => ["1", " ", " 1a", " 3"] => [1, 0, 1, 3] => "1,0,1,3")
    self.distances = distances_arr.map { |d| d.strip.to_i }.join(",")
  end
end
