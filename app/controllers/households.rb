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

          # GET /households/[househ_id]
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

          # POST /households/[househ_id]/collaborators
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

        #   # POST /households/[househ_id]/members/
          routing.post('members') do
            print("Creating member")
            member_data = Form::NewMember.new.call(routing.params)
            if member_data.failure?
              flash[:error] = Form.message_values(member_data)
              routing.halt
            end

            CreateNewMember.new(App.config).call(
              current_account: @current_account,
              household_id: househ_id,
              member_data: member_data.to_h
            )

            flash[:notice] = 'Your member was added'
          rescue StandardError => e
            puts "ERROR CREATING MEMBER: #{e.inspect}"
            flash[:error] = 'Could not add member'
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

        # POST /households/
        routing.post do
          print("start households post\n")
          routing.redirect '/auth/login' unless @current_account.logged_in?
          print("we're logged in\n")
          household_data = Form::NewHousehold.new.call(routing.params)
          print("household_data is",household_data.to_s,"\n")
          if household_data.failure?
            print("we're halted\n")
            flash[:error] = Form.message_values(household_data)
            routing.halt
          end
          print("(In controller) household_data is",household_data.to_s,"\n")

          CreateNewHousehold.new(App.config).call(
            current_account: @current_account,
            household_data: household_data.to_h
          )
          print("we're done\n")

          flash[:notice] = 'Add member and collaborators to your new household'
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
