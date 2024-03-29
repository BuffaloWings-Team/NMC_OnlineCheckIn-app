# frozen_string_literal: true

require 'http'

module OnlineCheckIn
  # Create a new configuration file for a household
  class CreateNewMember
    def initialize(config)
      @config = config
    end

    def api_url
      @config.API_URL
    end

    def call(current_account:, household_id:, member_data:)
      config_url = "#{api_url}/households/#{household_id}/members"
      response = HTTP.auth("Bearer #{current_account.auth_token}")
                    .post(config_url, json: member_data)

      response.code == 201 ? JSON.parse(response.body.to_s) : raise
    end
  end
end
