# frozen_string_literal: true

require 'http'

module OnlineCheckIn
  # Returns all households belonging to an account
  class GetMember
    def initialize(config)
      @config = config
    end

    def call(user, member_id)
      response = HTTP.auth("Bearer #{user.auth_token}")
                    .get("#{@config.API_URL}/members/#{member_id}")

      response.code == 200 ? JSON.parse(response.body.to_s)['data'] : nil
    end
  end
end