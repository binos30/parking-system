# frozen_string_literal: true

FactoryBot.define do
  factory :parking_lot do
    sequence(:name) { |n| "PL #{n}" }

    transient { slots_count { 2 } }

    after(:build) { |parking_lot, evaluator| build_list(:parking_slot, evaluator.slots_count, parking_lot:) }
  end
end
