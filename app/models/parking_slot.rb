# frozen_string_literal: true

class ParkingSlot < ApplicationRecord
  belongs_to :parking_lot

  validates :slot_type,
            presence: true,
            numericality: {
              only_integer: true
            },
            inclusion: {
              in: ParkingSlotType::TYPES.values
            }

  validate :validate_distances

  before_validation :set_distances

  def code
    id.to_s.rjust(3, "0")
  end

  private

  def validate_distances
    # Check if distances length/size is equal to the number of entrances
    return if distances.split(",").size == Entrance.count
    errors.add(:base, "has invalid distances.")
  end

  def set_distances
    # Split the distances into an array then remove whitespace
    # and convert each value to an array of integers then return to string
    # If there is not a valid number at the start of str, 0 is returned
    # (e.g. "1, , 1a, 3" => ["1", " ", " 1a", " 3"] => [1, 0, 1, 3] => "1,0,1,3")
    self.distances = distances.split(",").map { |d| d.strip.to_i }.join(",")
  end
end
