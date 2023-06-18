# frozen_string_literal: true

module OnlineCheckIn
    # Service to add member to household
    class RemoveMember
      class MemberNotRemoved < StandardError; end
  
      def initialize(config)
        @config = config
      end
  
      def api_url
        @config.API_URL
      end
  
      def call(current_account:, household_id:, member_data:)
        config_url = "#{api_url}/households/#{household_id}/members"
        response = HTTP.auth("Bearer #{current_account.auth_token}")
                      .delete(config_url, json: member_data)
  
        raise MemberNotRemoved unless response.code == 200
      end
    end
  end