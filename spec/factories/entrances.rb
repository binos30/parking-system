# frozen_string_literal: true

FactoryBot.define do
  factory :entrance do
    sequence(:name) { |n| "Entrance #{n}" }
  end
end
