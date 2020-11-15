# frozen_string_literal: true

class CreatePayments < ActiveRecord::Migration[6.0]
  def change
    create_table :payments do |t|
      t.date :payment_date

      t.timestamps
    end
  end
end
