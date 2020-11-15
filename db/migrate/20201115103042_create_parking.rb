# frozen_string_literal: true

class CreateParking < ActiveRecord::Migration[6.0]
  def change
    create_table :parking do |t|
      t.date :entrance_date
      t.date :exit_date
      t.date :payment_date

      t.references :vehicle, foreign_key: true

      t.timestamps
    end
  end
end
