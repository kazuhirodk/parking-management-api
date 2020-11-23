# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

require 'rails_helper'

RSpec.describe Api::V1::ParkingController, type: :controller do
  before(:each) do
    post :enter_parking, params: { plate: 'ABC-9999' }
  end

  describe 'POST #enter_parking' do
    it 'must create vehicle and parking ticket' do
      parking = Parking.last
      expected_response = JSON.parse(
        {
          data: { ticket_number: parking.id },
          message: 'Enter parking successfully.'
        }.to_json
      )

      expect(response.status).to eq(201)
      expect(JSON.parse(response.body)).to eq(expected_response)
      expect(Vehicle.count).to eq(1)
      expect(Parking.count).to eq(1)
      expect(Vehicle.last.plate).to eq('ABC-9999')
    end
  end

  describe 'PUT #pay_parking' do
    it 'must update status to paid and add payment_data to parking' do
      parking = Parking.last

      expected_response = JSON.parse(
        {
          data: {},
          message: 'Parking ticket has paid successfully.'
        }.to_json
      )

      put :pay_parking, params: { id: parking.id }

      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)).to eq(expected_response)
      expect(Vehicle.count).to eq(1)
      expect(Parking.count).to eq(1)
      expect(Vehicle.last.plate).to eq('ABC-9999')
      expect(Parking.last.status).to eq('paid')
      expect(Parking.last.payment_date).not_to be_nil
    end
  end

  describe 'PUT #left_parking' do
    it 'must update status to left and add exit_date to parking' do
      parking = Parking.last

      expected_response = JSON.parse(
        {
          data: {},
          message: 'Vehicle has left successfully.'
        }.to_json
      )

      put :pay_parking, params: { id: parking.id }
      put :left_parking, params: { id: parking.id }

      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)).to eq(expected_response)
      expect(Vehicle.count).to eq(1)
      expect(Parking.count).to eq(1)
      expect(Vehicle.last.plate).to eq('ABC-9999')
      expect(Parking.last.status).to eq('left')
      expect(Parking.last.exit_date).not_to be_nil
    end
  end

  describe 'GET #parking_history' do
    it 'must list parking history from vehicle' do
      parking = Parking.last

      expected_response = JSON.parse([
        id: parking.id,
        left: true,
        paid: true,
        time: '0 minutes'
      ].to_json)

      put :pay_parking, params: { id: parking.id }
      put :left_parking, params: { id: parking.id }
      get :parking_history, params: { plate: 'ABC-9999' }

      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)).to eq(expected_response)
    end
  end
end
# rubocop:enable Metrics/BlockLength
