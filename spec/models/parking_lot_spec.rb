# frozen_string_literal: true

require "rails_helper"

RSpec.describe ParkingLot, type: :model do
  describe "db_columns" do
    it { should have_db_column(:name).of_type(:string).with_options(null: false) }
  end

  describe "db_indexes" do
    it { should have_db_index(:name).unique }
  end

  describe "associations" do
    describe "has_many" do
      it { should have_many(:parking_slots).inverse_of(:parking_lot).dependent(:destroy) }
    end
  end

  describe "validations" do
    describe "presence" do
      it { should validate_presence_of(:name) }
    end

    describe "length" do
      it { should validate_length_of(:name).is_at_least(2).is_at_most(15) }
    end

    describe "uniqueness" do
      subject { build :parking_lot }

      it { should validate_uniqueness_of(:name).case_insensitive }
    end

    describe "format" do
      subject { build :parking_lot }

      before { create_pair(:entrance) }

      describe "name" do
        it "accepts a valid value" do
          subject.name = "ParkingLot"
          expect(subject).to be_valid
        end

        it "does not accept an invalid format" do
          subject.name = "ParkingLot<1"
          expect(subject).to be_invalid
        end
      end
    end

    describe "validate_has_one_slot" do
      subject { build :parking_lot }

      it "is valid" do
        expect(subject.valid?).to be true
      end

      context "when there are no parking_slots" do
        before { subject.parking_slots = [] }

        it "is has an error on parking_lot" do
          subject.validate
          expect(subject.errors[:parking_lot].first).to eq("needs at least one slot.")
        end
      end
    end
  end
end
