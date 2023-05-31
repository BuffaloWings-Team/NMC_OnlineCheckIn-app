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
      @documents = process_documents(relationships['documents'])
    end

    def process_policies(policies)
      @policies = OpenStruct.new(policies)
    end

    def process_documents(documents_info)
      return nil unless documents_info

      documents_info.map { |doc_info| Document.new(doc_info) }
    end

    def process_collaborators(collaborators)
      return nil unless collaborators

      collaborators.map { |account_info| Account.new(account_info) }
    end
  end
end
