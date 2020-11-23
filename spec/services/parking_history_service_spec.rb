# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

require 'rails_helper'

RSpec.describe ParkingHistoryService, type: :service do
  let(:vehicle) { create(:vehicle) }
  let!(:parking_initiated) do
    create(
      :parking,
      entrance_date: Time.current,
      status: 'initiated',
      vehicle: vehicle
    )
  end
  let!(:parking_paid) do
    create(
      :parking,
      entrance_date: Time.current,
      payment_date: Time.current + 2.minutes,
      status: 'paid',
      vehicle: vehicle
    )
  end
  let!(:parking_left) do
    create(
      :parking,
      entrance_date: Time.current,
      payment_date: Time.current + 2.minutes,
      exit_date: Time.current + 5.minutes,
      status: 'left',
      vehicle: vehicle
    )
  end

  describe '#full_history' do
    context 'when inform a invalid plate' do
      it 'must return :not_found response' do
        plate = 'abc-999'
        response = described_class.new({ plate: plate }).full_history

        expect(response).to eq(
          described_class.new({ plate: plate }).send(:invalid_vehicle_response)
        )
      end
    end

    context 'when inform a valid plate with parking tickets' do
      it 'must return a object array with all parking tickets with status :ok' do
        response = described_class.new({ plate: vehicle.plate }).full_history
        ids = vehicle.parking.pluck(:id)

        expected_response = {
          message: 'Parking history was successfully obtained',
          data: [
            {
              'id' => ids[0],
              'left' => false,
              'paid' => false,
              'time' => '0 minutes'
            },
            {
              'id' => ids[1],
              'left' => false,
              'paid' => true,
              'time' => '0 minutes'
            },
            {
              'id' => ids[2],
              'left' => true,
              'paid' => true,
              'time' => '5 minutes'
            }
          ],
          http_status: :ok
        }

        expect(response).to eq(expected_response)
      end
    end
  end

  describe '#get_ticket_time_in_minutes' do
    let(:current_time) { Time.current }
    let(:vehicle_time) { create(:vehicle, plate: 'ABC-9999') }
    let!(:parking_time) do
      create(
        :parking,
        entrance_date: current_time - 3.minutes,
        vehicle: vehicle_time
      )
    end

    it 'must return the difference between entrance_date with current_date (if has no exit date)' do
      expect(
        described_class.new.send(:get_ticket_time_in_minutes, parking_time)
      ).to eq('3 minutes')
    end

    it 'must return the difference between entrance_date with exit_date' do
      parking_time.exit_date = current_time + 22.minutes
      parking_time.save!

      expect(
        described_class.new.send(:get_ticket_time_in_minutes, parking_time)
      ).to eq('25 minutes')
    end
  end

  describe '#history_list' do
    context 'when vehicle has multiple parking history' do
      it 'must return a object array with all parking tickets with status :ok' do
        response = described_class.new({ plate: vehicle.plate }).send(:history_list)
        ids = vehicle.parking.pluck(:id)

        expect(response).to eq(
          [
            {
              'id' => ids[0],
              'left' => false,
              'paid' => false,
              'time' => '0 minutes'
            },
            {
              'id' => ids[1],
              'left' => false,
              'paid' => true,
              'time' => '0 minutes'
            },
            {
              'id' => ids[2],
              'left' => true,
              'paid' => true,
              'time' => '5 minutes'
            }
          ]
        )
      end
    end

    context 'when vehicle has no parking history' do
      let(:new_vehicle) { create(:vehicle, plate: 'LOL-2020') }

      it 'must return a empty array' do
        response = described_class.new({ plate: new_vehicle.plate }).send(:history_list)

        expect(response).to eq([])
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
