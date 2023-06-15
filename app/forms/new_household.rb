# frozen_string_literal: true

require_relative 'form_base'

module OnlineCheckIn
  module Form
    class NewHousehold < Dry::Validation::Contract
      config.messages.load_paths << File.join(__dir__, 'errors/new_household.yml')

      params do
        required(:houseowner).filled
        required(:floorNo).filled
        required(:roomNo).filled
        required(:ping).filled
        required(:email).filled
        required(:phonenumber).filled
      end
    end
  end
end
