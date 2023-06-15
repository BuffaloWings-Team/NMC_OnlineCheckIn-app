# frozen_string_literal: true

require_relative 'form_base'

module OnlineCheckIn
  module Form
    class NewHousehold < Dry::Validation::Contract
      config.messages.load_paths << File.join(__dir__, 'errors/new_household.yml')

      params do
        required(:homeowner).filled
        optional(:floorNo).filled
        required(:contact).filled
      end
    end
  end
end
