# frozen_string_literal: true

require 'roda'

module OnlineCheckIn
  # Web controller for OnlineCheckIn API
  class App < Roda
    route('members') do |routing|
      routing.redirect '/auth/login' unless @current_account.logged_in?

      # GET /members/[member_id]
      routing.get(String) do |member_id|
        member_info = GetMember.new(App.config)
                              .call(@current_account, member_id)
        member = Member.new(member_info)

        view :member, locals: {
          current_account: @current_account, member: member
        }
      end
    end
  end
end