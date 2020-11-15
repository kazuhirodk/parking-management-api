# frozen_string_literal: true

class Parking < ApplicationRecord
  self.table_name = 'parking'

  validates :entrance_date, presence: true
  validates :vehicle_id, presence: true

  belongs_to :vehicle
end
