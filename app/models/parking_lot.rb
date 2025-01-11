# frozen_string_literal: true

class ParkingLot < ApplicationRecord
  has_many :parking_slots, inverse_of: :parking_lot, dependent: :destroy

  accepts_nested_attributes_for :parking_slots,
                                reject_if:
                                  proc { |parking_slot|
                                    parking_slot["slot_type"].blank? && parking_slot["distances"].blank?
                                  },
                                allow_destroy: true

  validates :name,
            presence: true,
            uniqueness: {
              case_sensitive: false
            },
            length: {
              in: 2..15
            },
            format: %r{\A[a-zA-Z0-9\s\-/&]*\z}

  validate :validate_has_one_slot

  private

  def validate_has_one_slot
    errors.add(:parking_lot, "needs at least one slot.") if parking_slots.empty?
  end
end
