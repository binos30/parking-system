# frozen_string_literal: true

require "rails_helper"

RSpec.describe Api::V1::ParkingLotsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/api/v1/parking_lots").to route_to("api/v1/parking_lots#index", format: :json)
    end

    it "routes to #show" do
      expect(get: "/api/v1/parking_lots/1").to route_to("api/v1/parking_lots#show", id: "1", format: :json)
    end

    it "routes to #create" do
      expect(post: "/api/v1/parking_lots").to route_to("api/v1/parking_lots#create", format: :json)
    end

    it "routes to #update via PUT" do
      expect(put: "/api/v1/parking_lots/1").to route_to("api/v1/parking_lots#update", id: "1", format: :json)
    end

    it "routes to #update via PATCH" do
      expect(patch: "/api/v1/parking_lots/1").to route_to("api/v1/parking_lots#update", id: "1", format: :json)
    end

    it "routes to #destroy" do
      expect(delete: "/api/v1/parking_lots/1").to route_to("api/v1/parking_lots#destroy", id: "1", format: :json)
    end
  end
end
