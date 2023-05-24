# frozen_string_literal: true

module OnlineCheckIn
    # Behaviors of the currently logged in account
    class Household
      attr_reader :id, :name, :repo_url
  
      def initialize(house_info)
        @id = house_info['attributes']['id']
        @name = house_info['attributes']['name']
        @repo_url = house_info['attributes']['repo_url']
      end
    end
  end
  