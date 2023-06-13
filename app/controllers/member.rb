# frozen_string_literal: true

require 'roda'
require_relative './app'

module OnlineCheckIn
  # Web controller for OnlineCheckIn API
  class App < Roda
    route('members') do |routing|
      routing.redirect '/auth/login' unless @current_account.logged_in?

      # GET /members/[doc_id]
      routing.get(String) do |doc_id|
        doc_info = GetMember.new(App.config)
                              .call(@current_account, doc_id)
        member = Member.new(doc_info)

        view :member, locals: {
          current_account: @current_account, member: member
        }
      end
    end
  end
end
