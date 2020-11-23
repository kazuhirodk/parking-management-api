# frozen_string_literal: true

class Parking < ApplicationRecord
  self.table_name = 'parking'

  enum status: { initiated: 0, paid: 1, left: 2 }

  validates :entrance_date, presence: true
  validates :vehicle_id, presence: true
  validates :status, presence: true

  belongs_to :vehicle

  def parking_paid?
    paid? || payment_date.present?
  end
end
