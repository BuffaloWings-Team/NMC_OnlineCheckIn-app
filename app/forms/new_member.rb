# frozen_string_literal: true

require_relative 'form_base'

module OnlineCheckIn
  module Form
    class NewMember < Dry::Validation::Contract
      config.messages.load_paths << File.join(__dir__, 'errors/new_member.yml')

      params do
        required(:first_name).filled(:string)
        required(:last_name).maybe(:string)
        required(:dob).maybe(:string)

      end
    end
  end
end