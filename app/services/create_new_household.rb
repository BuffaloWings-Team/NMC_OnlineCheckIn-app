# frozen_string_literal: true

require 'http'

module OnlineCheckIn
  # Create a new configuration file for a household
  class CreateNewHousehold
    def initialize(config)
      @config = config
    end

    def api_url
      @config.API_URL
    end

    def call(current_account:, household_data:)
      config_url = "#{api_url}/households"
      response = HTTP.auth("Bearer #{current_account.auth_token}")
                    .post(config_url, json: household_data)

      response.code == 201 ? JSON.parse(response.body.to_s) : raise
    end
  end
end
