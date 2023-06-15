# frozen_string_literal: true

require 'http'

module OnlineCheckIn
  # Returns all households belonging to an account
  class GetHousehold
    def initialize(config)
      @config = config
    end

    def call(current_account, househ_id)
      print("househ_id: #{househ_id}")
      response = HTTP.auth("Bearer #{current_account.auth_token}")
                    .get("#{@config.API_URL}/households/#{househ_id}")

      response.code == 200 ? JSON.parse(response.body.to_s)['data'] : nil
    end
  end
end
