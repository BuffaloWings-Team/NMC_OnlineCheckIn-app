# frozen_string_literal: true

require_relative 'household'

module OnlineCheckIn
  # Behaviors of the currently logged in account
  class Memeber
    attr_reader :id, :filename, :relative_path, :description, # basic info
                :content,
                :household # full details

    def initialize(info)
      process_attributes(info['attributes'])
      process_included(info['include'])
    end

    private

    def process_attributes(attributes)
      @id             = attributes['id']
      @filename       = attributes['filename']
      @relative_path  = attributes['relative_path']
      @description    = attributes['description']
      @content        = attributes['content']
    end

    def process_included(included)
      @household = Houeholds.new(included['household'])
    end
  end
end
