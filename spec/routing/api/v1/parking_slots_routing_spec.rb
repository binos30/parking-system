# frozen_string_literal: true

require "rails_helper"

RSpec.describe Api::V1::ParkingSlotsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/api/v1/parking_slots").to route_to("api/v1/parking_slots#index", format: :json)
    end
  end
end
