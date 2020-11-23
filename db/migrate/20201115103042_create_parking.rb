# frozen_string_literal: true

class CreateParking < ActiveRecord::Migration[6.0]
  def change
    create_table :parking do |t|
      t.datetime :entrance_date
      t.datetime :payment_date
      t.datetime :exit_date
      t.integer :status

      t.references :vehicle, foreign_key: true

      t.timestamps
    end
  end
end
