# frozen_string_literal: true

require_relative 'household'

module OnlineCheckIn
  # Behaviors of the currently logged in account
  class Member
    attr_reader :id, :firstname, :lastname, :dob, # basic info
                :household # full details

    def initialize(member_info)
      process_attributes(member_info['attributes'])
      process_included(member_info['include'])
    end

    private

    def process_attributes(attributes)
      @id             = attributes['id']
      @firstname     = attributes['firstname']
      @lastname      = attributes['lastname']
      @dob            = attributes['dob']
    end

    def process_included(included)
      @household = Household.new(included['household'])
    end
  end
end