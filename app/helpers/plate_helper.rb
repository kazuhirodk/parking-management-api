# frozen_string_literal: true

module PlateHelper
  def self.valid_plate?(plate)
    regex_match = plate =~ /[A-Z]{3}-[0-9]{4}/

    !regex_match.nil?
  end
end
