# frozen_string_literal: true

require 'roda'

module OnlineCheckIn
  # Web controller for OnlineCheckin API
  class App < Roda
    route('households') do |routing|
      routing.on do
        # GET /households/
        routing.get do
          if @current_account.logged_in?
            household_list = GetAllHouseholds.new(App.config).call(@current_account)

            households = Households.new(household_list)

            view :households_all,
                 locals: { current_user: @current_account, households: }
          else
            routing.redirect '/auth/login'
          end
        end
      end
    end
  end
end
