# frozen_string_literal: true

require 'http'

module OnlineCheckIn
  # Returns all projects belonging to an account
  class GetMember
    def initialize(config)
      @config = config
    end

    def call(user, memb_id)
      response = HTTP.auth("Bearer #{user.auth_token}")
                    .get("#{@config.API_URL}/members/#{memb_id}")

      response.code == 200 ? JSON.parse(response.body.to_s)['data'] : nil
    end
  end
end
