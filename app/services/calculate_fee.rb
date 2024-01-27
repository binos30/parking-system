# frozen_string_literal: true

class CalculateFee
  BASE_FEE = 40.0
  SP_HOURLY_RATE = 20.0
  MP_HOURLY_RATE = 60.0
  LP_HOURLY_RATE = 100.0
  RATE_PER_24H = 5000.0

  def initialize(unpark_date, date_park, slot_type)
    @unpark_date = unpark_date
    @date_park = date_park
    @slot_type = slot_type
  end

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
  def call # rubocop:disable Metrics/AbcSize,Metrics/CyclomaticComplexity,Metrics/PerceivedComplexity
    base_hours = 3
    h = ((@unpark_date - @date_park) / 1.hour).ceil

    if h <= base_hours
      BASE_FEE
    elsif h == 24
      RATE_PER_24H
    elsif h > 24
      case @slot_type
      when "small"
        RATE_PER_24H + ((h - 24) * SP_HOURLY_RATE)
      when "medium"
        RATE_PER_24H + ((h - 24) * MP_HOURLY_RATE)
      when "large"
        RATE_PER_24H + ((h - 24) * LP_HOURLY_RATE)
      else
        raise "Unknown parking slot type"
      end
    else
      case @slot_type
      when "small"
        BASE_FEE + ((h - base_hours) * SP_HOURLY_RATE)
      when "medium"
        BASE_FEE + ((h - base_hours) * MP_HOURLY_RATE)
      when "large"
        BASE_FEE + ((h - base_hours) * LP_HOURLY_RATE)
      else
        raise "Unknown parking slot type"
      end
    end
  end
end
