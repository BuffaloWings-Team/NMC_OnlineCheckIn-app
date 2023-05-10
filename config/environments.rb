# frozen_string_literal: true

require 'roda'
require 'figaro'
require 'logger'
require 'rack/ssl-enforcer'

module OnlineCheckIn
  # Configuration for the API
  class App < Roda
    plugin :environments

    # Environment variables setup
    Figaro.application = Figaro::Application.new(
      environment:,
      path: File.expand_path('config/secrets.yml')
    )
    Figaro.load
    def self.config = Figaro.env

    # Logger setup
    LOGGER = Logger.new($stderr)
    def self.logger = LOGGER

    # With production no need of TLS certificates set up, and easier to develope
    configure :production do
      # (HSTS) Sets a browser side policy to enforce TLS/SSL
      # HSTS should be on APP due difficulties of changes if it was on local host
      use Rack::SslEnforcer, hsts: true
    end

    configure :development, :test do
      require 'pry'

      # Allows running reload! in pry to restart entire app
      def self.reload!
        exec 'pry -r ./spec/test_load_all'
      end
    end
  end
end
