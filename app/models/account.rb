# frozen_string_literal: true

module OnlineCheckIn
  # Behaviors of the currently logged in account
  class Account
    def initialize(account_info = nil, auth_token = nil)
      @account_info = account_info
      @auth_token = auth_token
    end

    attr_reader :account_info, :auth_token

    def username
      if @account_info['attributes']['username'].nil?
        print("account_info is nil\n")
      end
      @account_info['attributes']['username'] ? @account_info['attributes']['username'] : "Not provided"
    end

    def email
      if @account_info['attributes']['email'].nil?
        print("account_info is nil\n")
      end
      @account_info['attributes']['email'] ? @account_info['attributes']['email'] : "NotProvided@gmail.com"
    end

    def logged_out?
      @account_info.nil?
    end

    def logged_in?
      !logged_out?
    end
  end
end
