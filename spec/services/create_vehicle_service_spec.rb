# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

require 'rails_helper'

RSpec.describe CreateVehicleService, type: :service do
  describe '#valid_plate?' do
    context 'When plate param is AAA-9999 format' do
      it 'must return false' do
        expect(described_class.new(plate: 'ABC-8888').send(:valid_plate?)).to be_truthy
        expect(described_class.new(plate: 'QUE-9999').send(:valid_plate?)).to be_truthy
      end
    end

    context 'When plate param is not AAA-9999 format' do
      it 'must return false' do
        expect(described_class.new(plate: 'abc-88').send(:valid_plate?)).to be_falsey
        expect(described_class.new(plate: 'abc-8888').send(:valid_plate?)).to be_falsey
        expect(described_class.new(plate: '123-9999').send(:valid_plate?)).to be_falsey
      end
    end
  end

  describe '#create_vehicle' do
    context 'When inform plate' do
      it 'must find or create vehicle' do
        plate = 'ABC-1234'
        first_vehicle = described_class.new(plate: plate).send(:create_vehicle)

        expect(first_vehicle.plate).to eq(plate)

        second_vehicle = described_class.new(plate: plate).send(:create_vehicle)

        expect(first_vehicle).to eq(second_vehicle)
      end
    end
  end

  describe '#create' do
    context 'When inform a valid plate' do
      it 'must find or create vehicle' do
        plate = 'ABC-1234'
        first_vehicle = described_class.new(plate: plate).create

        expect(first_vehicle.plate).to eq(plate)

        second_vehicle = described_class.new(plate: plate).create

        expect(first_vehicle).to eq(second_vehicle)
      end
    end

    context 'When inform a NOT valid plate' do
      it 'do not create vehicle' do
        plate = 'abc-1234'
        vehicle = described_class.new(plate: plate).create

        expect(vehicle).to be_nil
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
