# frozen_string_literal: true

class Booking < ApplicationRecord
  enum vehicle_type: { small: 0, medium: 1, large: 2 }

  belongs_to :parking_slot

  validates :vehicle_type, presence: true, inclusion: { in: vehicle_types.keys }
  validates :plate_number, presence: true, length: { minimum: 2, maximum: 9 }
  validates_comparison_of :date_unpark,
                          greater_than: :date_park,
                          message: "must be after date park",
                          if: -> { date_unpark.present? }

  def plate_number=(value)
    self[:plate_number] = value.upcase
  end

  def park_vehicle!(slot, params)
    lock!
    raise "Vehicle already parked." if date_park.present?

    parking_slot.vacant! if parking_slot_id != slot.id
    update!(params.merge(parking_slot: slot))

    raise "Slot already occupied." if slot.occupied?
    slot.occupied!
  end

  def unpark_vehicle!(params) # rubocop:disable Metrics/AbcSize
    lock!
    raise "Vehicle already unparked." if date_unpark.present?

    unpark_date = Time.zone.parse(params[:date_unpark])
    self.fee = CalculateFee.new(unpark_date, date_park, parking_slot.slot_type).call
    update!(params)

    raise "Can't unpark, slot not occupied." unless parking_slot.occupied?
    parking_slot.vacant!
  end
end
