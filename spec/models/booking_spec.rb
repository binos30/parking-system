# frozen_string_literal: true

require "rails_helper"

RSpec.describe Booking do
  describe "db_columns" do
    it { should have_db_column(:parking_slot_id).of_type(:integer).with_options(null: false) }
    it { should have_db_column(:vehicle_type).of_type(:integer).with_options(null: false) }
    it { should have_db_column(:plate_number).of_type(:string).with_options(null: false) }
    it { should have_db_column(:date_park).of_type(:datetime) }
    it { should have_db_column(:date_unpark).of_type(:datetime) }

    it do
      expect(subject).to have_db_column(:fee).of_type(:decimal).with_options(
        null: false,
        default: 0.0,
        precision: 8,
        scale: 2
      )
    end
  end

  describe "db_indexes" do
    it { should have_db_index(:parking_slot_id) }
    it { should have_db_index(:plate_number) }
    it { should have_db_index(:vehicle_type) }
  end

  describe "associations" do
    describe "belongs_to" do
      it { should belong_to(:parking_slot).inverse_of(:bookings) }
    end
  end

  describe "validations" do
    describe "presence" do
      it { should validate_presence_of(:plate_number) }
    end

    describe "numericality" do
      it { should validate_numericality_of(:fee).is_greater_than_or_equal_to(0) }
    end

    describe "inclusion" do
      it { should validate_inclusion_of(:vehicle_type).in_array(described_class.vehicle_types.keys) }
    end

    describe "length" do
      it { should validate_length_of(:plate_number).is_at_least(2).is_at_most(9) }
    end

    describe "comparison" do
      subject { build(:booking) }

      context "when date_park is present" do
        before { subject.date_park = Date.current - 3.hours }

        context "when date_unpark is present" do
          before { subject.date_unpark = Date.current }

          it do
            expect(subject).to validate_comparison_of(:date_unpark).is_greater_than(:date_park).with_message(
              "must be after date park"
            )
          end
        end
      end
    end
  end
end
