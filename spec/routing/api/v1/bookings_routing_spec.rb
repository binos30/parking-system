# frozen_string_literal: true

require "rails_helper"

RSpec.describe Api::V1::BookingsController do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/api/v1/bookings").to route_to("api/v1/bookings#index", format: :json)
    end

    it "routes to #show" do
      expect(get: "/api/v1/bookings/1").to route_to("api/v1/bookings#show", id: "1", format: :json)
    end

    it "routes to #create" do
      expect(post: "/api/v1/bookings").to route_to("api/v1/bookings#create", format: :json)
    end

    it "routes to #update via PUT" do
      expect(put: "/api/v1/bookings/1").to route_to("api/v1/bookings#update", id: "1", format: :json)
    end

    it "routes to #update via PATCH" do
      expect(patch: "/api/v1/bookings/1").to route_to("api/v1/bookings#update", id: "1", format: :json)
    end

    it "routes to #destroy" do
      expect(delete: "/api/v1/bookings/1").to route_to("api/v1/bookings#destroy", id: "1", format: :json)
    end
  end
end
