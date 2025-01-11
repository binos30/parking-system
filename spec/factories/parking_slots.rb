# frozen_string_literal: true

FactoryBot.define do
  factory :parking_slot do
    parking_lot
    slot_type { :large }
    status { :vacant }
    distances { Array.new(Entrance.count) { |index| index + 1 }.join(",") }
  end
end
