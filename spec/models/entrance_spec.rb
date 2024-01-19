# frozen_string_literal: true

require "rails_helper"

RSpec.describe Entrance do
  it "does not save without name" do
    entrance = described_class.new
    expect(entrance.save).to be false
  end
end
