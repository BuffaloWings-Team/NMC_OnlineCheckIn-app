# frozen_string_literal: true

require 'roda'

module OnlineCheckIn
  # Web controller for OnlineCheckin API
  class App < Roda
    route('households') do |routing|
      routing.on do
        routing.redirect '/auth/login' unless @current_account.logged_in?
        @households_route = '/households'

        routing.on(String) do |househ_id|
          @household_route = "#{@households_route}/#{househ_id}"

          # GET /households/[proj_id]
        routing.get do
            house_info = GetHousehold.new(App.config).call(
              @current_account, househ_id
            )
            household = Household.new(house_info)

            view :household, locals: {
              current_account: @current_account, household: household
            }
          rescue StandardError => e
            puts "#{e.inspect}\n#{e.backtrace}"
            flash[:error] = 'Household not found'
            routing.redirect @households_route
          end

          # POST /households/[proj_id]/collaborators
          routing.post('collaborators') do
            action = routing.params['action']
            collaborator_info = Form::CollaboratorEmail.new.call(routing.params)
            if collaborator_info.failure?
              flash[:error] = Form.validation_errors(collaborator_info)
              routing.halt
            end

            task_list = {
              'add' => { service: AddCollaborator,
                         message: 'Added new collaborator to household' },
              'remove' => { service: RemoveCollaborator,
                            message: 'Removed collaborator from household' }
            }

            task = task_list[action]
            task[:service].new(App.config).call(
              current_account: @current_account,
              collaborator: collaborator_info,
              household_id: househ_id
            )
            flash[:notice] = task[:message]

          rescue StandardError
            flash[:error] = 'Could not find collaborator'
          ensure
            routing.redirect @household_route
          end

        #   # POST /projects/[proj_id]/documents/
          routing.post('documents') do
            document_data = Form::NewDocument.new.call(routing.params)
            if document_data.failure?
              flash[:error] = Form.message_values(document_data)
              routing.halt
            end

            CreateNewDocument.new(App.config).call(
              current_account: @current_account,
              household_id: househ_id,
              document_data: document_data.to_h
            )

            flash[:notice] = 'Your document was added'
          rescue StandardError => error
            puts error.inspect
            puts error.backtrace
            flash[:error] = 'Could not add document'
          ensure
            routing.redirect @household_route
          end
        end

        # GET /households/
        routing.get do
          household_list = GetAllHouseholds.new(App.config).call(@current_account)

          households = Households.new(household_list)

          view :households_all, locals: {
            current_account: @current_account, households: households
          }
        end

        # POST /projects/
        routing.post do
          routing.redirect '/auth/login' unless @current_account.logged_in?
          puts "HOUSEH: #{routing.params}"
          household_data = Form::NewHousehold.new.call(routing.params)
          if household_data.failure?
            flash[:error] = Form.message_values(household_data)
            routing.halt
          end

          CreateNewHousehold.new(App.config).call(
            current_account: @current_account,
            household_data: household_data.to_h
          )

          flash[:notice] = 'Add documents and collaborators to your new household'
        rescue StandardError => e
          puts "FAILURE Creating Household: #{e.inspect}"
          flash[:error] = 'Could not create household'
        ensure
          routing.redirect @households_route
        end
      end
    end
  end
end
