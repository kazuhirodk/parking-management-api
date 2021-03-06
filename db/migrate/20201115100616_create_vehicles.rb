# frozen_string_literal: true

class CreateVehicles < ActiveRecord::Migration[6.0]
  def change
    create_table :vehicles do |t|
      t.string :plate, unique: true

      t.timestamps
    end
  end
end
