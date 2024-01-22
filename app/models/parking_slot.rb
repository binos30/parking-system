# frozen_string_literal: true

class ParkingSlot < ApplicationRecord
  enum slot_type: { small: 0, medium: 1, large: 2 }
  enum status: { vacant: 0, reserved: 1, occupied: 2 }, _default: :vacant

  belongs_to :parking_lot

  has_many :bookings, dependent: :restrict_with_exception

  validates :slot_type, presence: true, inclusion: { in: slot_types.keys }
  validates :status, presence: true, inclusion: { in: statuses.keys }

  validate :validate_distances

  before_validation :set_distances

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
    errors.add(:base, "has invalid distances.")
  end

  def set_distances
    # Split the distances into an array then remove whitespace
    # and convert each value to an array of integers then return to string
    # If there is not a valid number at the start of str, 0 is returned
    # (e.g. "1, , 1a, 3" => ["1", " ", " 1a", " 3"] => [1, 0, 1, 3] => "1,0,1,3")
    self.distances = distances_arr.map { |d| d.strip.to_i }.join(",")
  end
end
