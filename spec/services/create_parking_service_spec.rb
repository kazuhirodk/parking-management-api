# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

require 'rails_helper'

RSpec.describe CreateParkingService, type: :service do
  describe '#valid_vehicle?' do
    let(:vehicle) { create(:vehicle) }

    context 'When pass a existent vehicle_id' do
      it 'must return true' do
        expect(described_class.new(vehicle.id).send(:valid_vehicle?)).to be_truthy
      end
    end

    context 'When pass a nonexistent vehicle_id' do
      it 'must return false' do
        expect(described_class.new(999).send(:valid_vehicle?)).to be_falsey
      end
    end
  end

  describe '#create_parking_ticket' do
    let(:vehicle) { create(:vehicle) }

    it 'Must create parking based on informed vehicle_id with initiated status' do
      parking = described_class.new(vehicle.id).send(:create_parking_ticket)

      expect(parking.vehicle_id).to eq(vehicle.id)
      expect(parking.status).to eq('initiated')
    end
  end

  describe '#create' do
    let(:vehicle) { create(:vehicle) }

    context 'When inform a valid vehicle' do
      it 'must create a parking' do
        first_parking = described_class.new(vehicle.id).create

        expect(first_parking.vehicle_id).to eq(vehicle.id)

        second_parking = described_class.new(vehicle.id).create

        expect(first_parking).not_to eq(second_parking)
      end
    end

    context 'When inform a NOT valid vehicle' do
      it 'do not create parking' do
        vehicle = described_class.new(999).create

        expect(vehicle).to be_nil
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
