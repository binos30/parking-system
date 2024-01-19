# frozen_string_literal: true

class Entrance < ApplicationRecord
  validates :name,
            presence: true,
            length: {
              minimum: 1,
              maximum: 15
            },
            format: %r{\A[a-zA-Z0-9\s\-/&]*\z}
end
