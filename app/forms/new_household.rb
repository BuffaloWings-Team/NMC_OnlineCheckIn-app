# frozen_string_literal: true

require_relative 'form_base'

module OnlineCheckIn
  module Form
    class NewHousehold < Dry::Validation::Contract
      config.messages.load_paths << File.join(__dir__, 'errors/new_household.yml')

      params do
        required(:name).filled
        optional(:repo_url).maybe(format?: URI::DEFAULT_PARSER.make_regexp)
      end
    end
  end
end
