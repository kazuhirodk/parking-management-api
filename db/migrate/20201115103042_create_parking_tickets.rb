# frozen_string_literal: true

class CreateParkingTickets < ActiveRecord::Migration[6.0]
  def change
    create_table :parking_tickets do |t|
      t.date :entrance_date
      t.date :exit_date
      t.references :vehicle, foreign_key: true
      t.references :payment, foreign_key: true

      t.timestamps
    end
  end
end
