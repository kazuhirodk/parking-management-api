# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

require 'rails_helper'

RSpec.describe Parking, type: :model do
  subject do
    described_class.new(
      entrance_date: Time.current,
      vehicle: Vehicle.create(plate: 'ABC-9999'),
      status: 'initiated'
    )
  end

  describe 'Validations' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid without a entrance_date' do
      subject.entrance_date = nil

      expect(subject).to_not be_valid
    end

    it 'is not valid without a status' do
      subject.status = nil

      expect(subject).to_not be_valid
    end

    it 'is not valid without a vehicle' do
      subject.vehicle = nil

      expect(subject).to_not be_valid
    end
  end

  describe 'Associations' do
    it {
      should belong_to(:vehicle).without_validating_presence
    }
  end

  describe 'Enum fields' do
    enum_fields = %i[initiated paid left]
    it {
      should define_enum_for(:status).with_values(enum_fields)
    }
  end

  describe '#parking_paid?' do
    context 'When has payment_date' do
      let(:parking_with_payment_date) do
        create(
          :parking,
          payment_date: Time.current + 1.day
        )
      end

      it 'should return true' do
        expect(parking_with_payment_date.parking_paid?).to be_truthy
      end
    end

    context 'When has paid status' do
      let(:parking_with_paid_status) do
        create(
          :parking,
          status: 'paid'
        )
      end

      it 'should return true' do
        expect(parking_with_paid_status.parking_paid?).to be_truthy
      end
    end

    context 'When has no payment' do
      let(:parking_with_paid_status) do
        create(
          :parking
        )
      end

      it 'should return true' do
        expect(parking_with_paid_status.parking_paid?).to be_falsey
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
