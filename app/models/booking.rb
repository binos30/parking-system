# frozen_string_literal: true

class Booking < ApplicationRecord
  BASE_FEE = 40.0
  SP_HOURLY_RATE = 20.0
  MP_HOURLY_RATE = 60.0
  LP_HOURLY_RATE = 100.0
  RATE_PER_24H = 5000.0

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
    parking_slot.vacant! if parking_slot_id != slot.id
    update!(params.merge(parking_slot: slot))

    raise "Slot already occupied." if slot.occupied?
    slot.occupied!
  end

  def unpark_vehicle!(params)
    unpark_date = Time.zone.parse(params[:date_unpark])
    calculate_fee(unpark_date)
    update!(params)

    raise "Can't unpark, slot not occupied." unless parking_slot.occupied?
    parking_slot.vacant!
  end

  private

  # (a) All types of cars pay the flat rate of 40 pesos for the first three (3) hours;
  # (b) The exceeding hourly rate beyond the initial three (3) hours will be charged as follows:
  #       20/hour for vehicles parked in SP;
  #       60/hour for vehicles parked in MP; and
  #       100/hour for vehicles parked in LP
  #
  # Take note that exceeding hours are charged depending on parking slot size
  # regardless of vehicle size.
  # For parking that exceeds 24 hours, every full 24-hour chunk is charged 5,000 pesos
  # regardless of the parking slot.
  # The remainder hours are charged using the method explained in (b).
  # Parking fees are calculated using the rounding up method, e.g. 6.4 hours must be rounded to 7.
  #
  def calculate_fee(unpark_date) # rubocop:disable Metrics/AbcSize,Metrics/CyclomaticComplexity,Metrics/PerceivedComplexity
    base_hours = 3
    h = ((unpark_date - date_park) / 1.hour).ceil

    if h <= base_hours
      self.fee = BASE_FEE
    elsif h == 24
      self.fee = RATE_PER_24H
    elsif h > 24
      case parking_slot.slot_type
      when "small"
        self.fee = RATE_PER_24H + ((h - 24) * SP_HOURLY_RATE)
      when "medium"
        self.fee = RATE_PER_24H + ((h - 24) * MP_HOURLY_RATE)
      when "large"
        self.fee = RATE_PER_24H + ((h - 24) * LP_HOURLY_RATE)
      else
        raise "Unknown parking slot type"
      end
    else
      case parking_slot.slot_type
      when "small"
        self.fee = BASE_FEE + ((h - base_hours) * SP_HOURLY_RATE)
      when "medium"
        self.fee = BASE_FEE + ((h - base_hours) * MP_HOURLY_RATE)
      when "large"
        self.fee = BASE_FEE + ((h - base_hours) * LP_HOURLY_RATE)
      else
        raise "Unknown parking slot type"
      end
    end
  end
end
