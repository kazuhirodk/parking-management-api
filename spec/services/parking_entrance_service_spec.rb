# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

require 'rails_helper'

RSpec.describe ParkingEntranceService, type: :service do
  describe '#enter_parking' do
    context 'when inform a valid plate' do
      it 'must find or create a vehicle and create parking and return success response' do
        response = described_class.new({ plate: 'ABC-1234' }).enter_parking
        vehicle = Vehicle.where(plate: 'ABC-1234')
        parking = Parking.where(vehicle_id: vehicle.first.id)

        expect(vehicle.count).to eq(1)
        expect(parking.count).to eq(1)

        expect(parking.first.vehicle_id).to eq(vehicle.first.id)

        expect(response).to eq(
          described_class.new.send(
            :enter_successfully_response,
            { ticket_number: parking.first.id }
          )
        )

        described_class.new({ plate: 'ABC-1234' }).enter_parking
        vehicle = Vehicle.where(plate: 'ABC-1234')
        parking = Parking.where(vehicle_id: vehicle.last.id)

        expect(vehicle.count).to eq(1)
        expect(parking.count).to eq(2)
      end
    end

    context 'when inform a invalid plate' do
      it 'do not create vehicle or parking and return bad request response' do
        response = described_class.new({ plate: 'abc-1234' }).enter_parking
        vehicle = Vehicle.where(plate: 'abc-1234')
        parking = Parking.all

        expect(vehicle.count).to eq(0)
        expect(parking.count).to eq(0)

        expect(response).to eq(
          described_class.new.send(:invalid_vehicle_response)
        )
      end
    end
  end

  describe '#enter_successfully_response' do
    context 'When inform data param' do
      it 'must return object with data values' do
        response = described_class.new.send(
          :enter_successfully_response,
          'data test'
        )

        expect(response).to eq(
          {
            message: 'Enter parking successfully.',
            data: 'data test',
            http_status: :created
          }
        )
      end
    end

    context 'When do not inform data param' do
      it 'must return object with empty data values' do
        response = described_class.new.send(:enter_successfully_response)

        expect(response).to eq(
          {
            message: 'Enter parking successfully.',
            data: {},
            http_status: :created
          }
        )
      end
    end
  end

  describe '#invalid_vehicle_response' do
    context 'When inform data param' do
      it 'must return object with data values' do
        response = described_class.new.send(
          :invalid_vehicle_response,
          'data test'
        )

        expect(response).to eq(
          {
            message: 'Invalid plate format. Use AAA-9999 format.',
            data: 'data test',
            http_status: :bad_request
          }
        )
      end
    end

    context 'When do not inform data param' do
      it 'must return object with empty data values' do
        response = described_class.new.send(:invalid_vehicle_response)

        expect(response).to eq(
          {
            message: 'Invalid plate format. Use AAA-9999 format.',
            data: {},
            http_status: :bad_request
          }
        )
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
