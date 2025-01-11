# frozen_string_literal: true

class Entrance < ApplicationRecord
  validates :name,
            presence: true,
            uniqueness: {
              case_sensitive: false
            },
            length: {
              in: 1..15
            },
            format: %r{\A[a-zA-Z0-9\s\-/&]*\z}
end
