# frozen_string_literal: true

require "rails_helper"

RSpec.describe Entrance, type: :model do
  describe "db_columns" do
    it { should have_db_column(:name).of_type(:string).with_options(null: false) }
  end

  describe "db_indexes" do
    it { should have_db_index(:name).unique }
  end

  describe "validations" do
    describe "presence" do
      it { should validate_presence_of(:name) }
    end

    describe "length" do
      it { should validate_length_of(:name).is_at_least(1).is_at_most(15) }
    end

    describe "uniqueness" do
      subject { build :entrance }

      it { should validate_uniqueness_of(:name).case_insensitive }
    end

    describe "format" do
      subject { build :entrance }

      describe "name" do
        it "accepts a valid value" do
          subject.name = "Entrance"
          expect(subject).to be_valid
        end

        it "does not accept an invalid format" do
          subject.name = "Entrance<1"
          expect(subject).to be_invalid
        end
      end
    end
  end
end
