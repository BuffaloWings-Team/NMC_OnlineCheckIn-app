# frozen_string_literal: true

module OnlineCheckIn
    # Service to add collaborator to household
    class RemoveCollaborator
      class CollaboratorNotRemoved < StandardError; end
  
      def initialize(config)
        @config = config
      end
  
      def api_url
        @config.API_URL
      end
  
      def call(current_account:, collaborator:, household_id:)
        response = HTTP.auth("Bearer #{current_account.auth_token}")
                      .delete("#{api_url}/households/#{household_id}/collaborators",
                              json: { email: collaborator[:email] })
  
        raise CollaboratorNotRemoved unless response.code == 200
      end
    end
  end
  