# frozen_string_literal: true

class Vehicle < ApplicationRecord
  validates_presence_of :plate

  has_many :parking, dependent: :destroy
end
