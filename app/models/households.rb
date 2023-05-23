# frozen_string_literal: true

require_relative 'household'

module OnlineCheckIn
  # Behaviors of the currently logged in account
  class Households
    attr_reader :all

    def initialize(households_list)
      @all = households_list.map do |proj|
        Household.new(proj)
      end
    end
  end
end
