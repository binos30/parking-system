# frozen_string_literal: true

FactoryBot.define do
  factory :booking do
    parking_slot
    vehicle_type { :large }
    plate_number { "ABC123" }
  end
end
