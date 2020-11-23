# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Vehicle, type: :model do
  subject {
    described_class.new(
      plate: 'MLB-2020'
    )
  }

  describe 'Validations' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid without a plate' do
      subject.plate = nil

      expect(subject).to_not be_valid
    end
  end

  describe 'Associations' do
    it {
      should have_many(:parking).without_validating_presence
    }
  end
end
