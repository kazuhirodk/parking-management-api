# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

require 'rails_helper'

RSpec.describe ParkingExitService, type: :service do
  describe '#left_parking' do
    context 'when inform a valid parking_id' do
      let(:parking) { create(:parking) }

      it 'should confirm ticket to left and return :ok response' do
        parking.payment_date = Time.current
        parking.save!

        response = described_class.new(parking.id).left_parking
        parking = Parking.last

        expect(parking.status).to eq('left')
        expect(parking.exit_date).not_to be_nil
        expect(response).to eq(
          described_class.new(parking.id).send(:left_successfully_response)
        )
      end

      it 'should require payment if has no payment' do
        response = described_class.new(parking.id).left_parking
        parking = Parking.last

        expect(parking.status).to eq('initiated')
        expect(parking.exit_date).to be_nil
        expect(response).to eq(
          described_class.new(parking.id).send(:payment_required_response)
        )
      end
    end

    context 'when inform a invalid/nonexinstent parking_id' do
      it 'should return :not_found response' do
        response = described_class.new(999).left_parking

        expect(response).to eq(
          described_class.new(999).send(:invalid_ticket_response)
        )
      end
    end

    context 'when inform a already left parking' do
      let(:parking) { create(:parking) }

      it 'should return :method_not_allowed when already left' do
        parking.payment_date = Time.current
        parking.left!

        response = described_class.new(parking.id).left_parking

        expect(response).to eq(
          described_class.new(parking.id).send(:vehicle_already_left_response)
        )
      end
    end
  end

  describe '#confirm_vehicle_exit' do
    let!(:parking) { create(:parking) }

    it 'must update the exit_date and update status' do
      expect(parking.exit_date).to be_nil
      expect(parking.status).to eq('initiated')
      expect(Parking.count).to eq(1)

      described_class.new(parking.id).send(:confirm_vehicle_exit)

      parking = Parking.last

      expect(Parking.count).to eq(1)
      expect(parking.exit_date).not_to be_nil
      expect(parking.status).to eq('left')
    end
  end

  describe '#invalid_ticket_response' do
    let(:parking) { create(:parking) }

    context 'When inform data param' do
      it 'must return object with data values' do
        response = described_class.new(parking.id).send(
          :invalid_ticket_response,
          'data test'
        )

        expect(response).to eq(
          {
            message: 'Ticket not found. Inform a valid ticket number.',
            data: 'data test',
            http_status: :not_found
          }
        )
      end
    end

    context 'When do not inform data param' do
      it 'must return object with empty data values' do
        response = described_class.new(parking.id).send(:invalid_ticket_response)

        expect(response).to eq(
          {
            message: 'Ticket not found. Inform a valid ticket number.',
            data: {},
            http_status: :not_found
          }
        )
      end
    end
  end

  describe '#vehicle_already_left_response' do
    let(:parking) { create(:parking) }

    context 'When inform data param' do
      it 'must return object with data values' do
        response = described_class.new(parking.id).send(
          :vehicle_already_left_response,
          'data test'
        )

        expect(response).to eq(
          {
            message: 'Vehicle already left parking.',
            data: 'data test',
            http_status: :method_not_allowed
          }
        )
      end
    end

    context 'When do not inform data param' do
      it 'must return object with empty data values' do
        response = described_class.new(parking.id).send(:vehicle_already_left_response)

        expect(response).to eq(
          {
            message: 'Vehicle already left parking.',
            data: {},
            http_status: :method_not_allowed
          }
        )
      end
    end
  end

  describe '#left_successfully_response' do
    let(:parking) { create(:parking) }

    context 'When inform data param' do
      it 'must return object with data values' do
        response = described_class.new(parking.id).send(
          :left_successfully_response,
          'data test'
        )

        expect(response).to eq(
          {
            message: 'Vehicle has left successfully.',
            data: 'data test',
            http_status: :ok
          }
        )
      end
    end

    context 'When do not inform data param' do
      it 'must return object with empty data values' do
        response = described_class.new(parking.id).send(:left_successfully_response)

        expect(response).to eq(
          {
            message: 'Vehicle has left successfully.',
            data: {},
            http_status: :ok
          }
        )
      end
    end
  end

end
# rubocop:enable Metrics/BlockLength
