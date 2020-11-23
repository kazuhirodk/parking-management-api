# frozen_string_literal: true

class Vehicle < ApplicationRecord
  validates :plate, presence: true

  has_many :parking, dependent: :destroy
end
