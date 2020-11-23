# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

require 'rails_helper'

RSpec.describe ParkingPaymentService, type: :service do
  describe '#pay_parking' do
    context 'when inform a valid parking_id' do
      let(:parking) { create(:parking) }

      it 'should confirm ticket to paid and return :ok response' do
        response = described_class.new(parking.id).pay_parking
        parking = Parking.last

        expect(parking.status).to eq('paid')
        expect(parking.payment_date).not_to be_nil
        expect(response).to eq(
          described_class.new(parking.id).send(:paid_successfully_response)
        )
      end
    end

    context 'when inform a invalid/nonexinstent parking_id' do
      it 'should return :not_found response' do
        response = described_class.new(999).pay_parking

        expect(response).to eq(
          described_class.new(999).send(:invalid_ticket_response)
        )
      end
    end

    context 'when inform a paid parking' do
      let(:parking) { create(:parking) }

      it 'should return :method_not_allowed when already paid' do
        parking.paid!

        response = described_class.new(parking.id).pay_parking

        expect(response).to eq(
          described_class.new(parking.id).send(:ticket_already_paid_response)
        )
      end
    end
  end

  describe '#confirm_ticket_payment' do
    let!(:parking) { create(:parking) }

    it 'must update the payment_date and update status' do
      expect(parking.payment_date).to be_nil
      expect(parking.status).to eq('initiated')
      expect(Parking.count).to eq(1)

      described_class.new(parking.id).send(:confirm_ticket_payment)

      parking = Parking.last

      expect(Parking.count).to eq(1)
      expect(parking.payment_date).not_to be_nil
      expect(parking.status).to eq('paid')
    end
  end

  describe '#already_paid?' do
    let(:parking) { create(:parking) }

    context 'when parking has payment_date' do
      it 'must return true' do
        parking.payment_date = Time.current
        parking.save!

        expect(described_class.new(parking.id).send(:already_paid?)).to be_truthy
      end
    end

    context 'when parking has paid status' do
      it 'must return true' do
        parking.paid!

        expect(described_class.new(parking.id).send(:already_paid?)).to be_truthy
      end
    end

    context 'when parking is not paid' do
      it 'must return false' do
        expect(described_class.new(parking.id).send(:already_paid?)).to be_falsey
      end
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

  describe '#ticket_already_paid_response' do
    let(:parking) { create(:parking) }

    context 'When inform data param' do
      it 'must return object with data values' do
        response = described_class.new(parking.id).send(
          :ticket_already_paid_response,
          'data test'
        )

        expect(response).to eq(
          {
            message: 'Parking ticket has already paid/validated.',
            data: 'data test',
            http_status: :method_not_allowed
          }
        )
      end
    end

    context 'When do not inform data param' do
      it 'must return object with empty data values' do
        response = described_class.new(parking.id).send(:ticket_already_paid_response)

        expect(response).to eq(
          {
            message: 'Parking ticket has already paid/validated.',
            data: {},
            http_status: :method_not_allowed
          }
        )
      end
    end
  end

  describe '#paid_successfully_response' do
    let(:parking) { create(:parking) }

    context 'When inform data param' do
      it 'must return object with data values' do
        response = described_class.new(parking.id).send(
          :paid_successfully_response,
          'data test'
        )

        expect(response).to eq(
          {
            message: 'Parking ticket has paid successfully.',
            data: 'data test',
            http_status: :ok
          }
        )
      end
    end

    context 'When do not inform data param' do
      it 'must return object with empty data values' do
        response = described_class.new(parking.id).send(:paid_successfully_response)

        expect(response).to eq(
          {
            message: 'Parking ticket has paid successfully.',
            data: {},
            http_status: :ok
          }
        )
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
