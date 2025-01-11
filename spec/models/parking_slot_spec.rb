# frozen_string_literal: true

require "rails_helper"

RSpec.describe ParkingSlot, type: :model do
  describe "db_columns" do
    it { should have_db_column(:slot_type).of_type(:integer).with_options(null: false) }
    it { should have_db_column(:distances).of_type(:string).with_options(null: false) }
    it { should have_db_column(:parking_lot_id).of_type(:integer).with_options(null: false) }
    it { should have_db_column(:status).of_type(:integer) }
  end

  describe "db_indexes" do
    it { should have_db_index(:distances) }
    it { should have_db_index(:parking_lot_id) }
    it { should have_db_index(:slot_type) }
    it { should have_db_index(:status) }
  end

  describe "associations" do
    describe "belongs_to" do
      subject { build :parking_slot }

      it { should belong_to(:parking_lot).inverse_of(:parking_slots) }
    end

    describe "has_many" do
      it { should have_many(:bookings).inverse_of(:parking_slot).dependent(:restrict_with_exception) }
    end
  end

  describe "validations" do
    subject { build :parking_slot }

    describe "inclusion" do
      it { should validate_inclusion_of(:slot_type).in_array(ParkingSlot.slot_types.keys) }
      it { should validate_inclusion_of(:status).in_array(ParkingSlot.statuses.keys) }
    end

    describe "validate_distances" do
      before { create_pair(:entrance) }

      it "is valid" do
        expect(subject.valid?).to be true
      end

      context "when distances_arr is not equal to Entrance.count" do
        before { subject.distances = "1" }

        it "is has an error on distances" do
          subject.validate
          expect(subject.errors[:distances].first).to eq("are invalid.")
        end
      end
    end
  end
end
