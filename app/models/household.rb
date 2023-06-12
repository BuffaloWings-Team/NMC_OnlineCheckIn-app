# frozen_string_literal: true

module OnlineCheckIn
  # Behaviors of the currently logged in account
  class Household
    attr_reader :id, :name, :repo_url

    def initialize(househ_info)
      process_attributes(househ_info['attributes'])
      process_relationships(househ_info['relationships'])
      process_policies(househ_info['policies'])
    end

    private

    def process_attributes(attributes)
      @id = attributes['id']
      @name = attributes['name']
      @repo_url = attributes['repo_url']
    end

    def process_relationships(relationships)
      return unless relationships

      @owner = Account.new(relationships['owner'])
      @collaborators = process_collaborators(relationships['collaborators'])
      @members = process_members(relationships['members'])
    end

    def process_policies(policies)
      @policies = OpenStruct.new(policies)
    end

    def process_members(members_info)
      return nil unless members_info

      members_info.map { |member_info| Member.new(member_info) }
    end

    def process_collaborators(collaborators)
      return nil unless collaborators

      collaborators.map { |account_info| Account.new(account_info) }
    end
  end
end
