require 'json'
module TrafficSpy
  class Server < Sinatra::Base

    get '/' do
      erb :index
    end


    not_found do
      erb :error
    end


    post '/sources' do

      reg = Registration.new({ identifier: params["identifier"], url: params["rootUrl"] })

      if params['identifier'] == nil || params['rootUrl'] == nil
        status 400
        body "Missing Parameters - 400 Bad Request"
      else
        if reg.save
          status 200
          body "{'identifier' : '#{params['identifier']}'}"
        else
          status 403
          body "Identifier Already Exists - 403 Forbidden"
        end

      end
    end

    post "/sources/:identifier/data" do |identifier|
      payload_handler = PayloadHandler.new(params[:payload], identifier)

      status payload_handler.status
      body payload_handler.body
    end

  end

end

#### REFACTORING

# We took the logic in "/sources/:identifier/data" and moved it to a payload handler.
# Refactor payload handler into a parser and handler
  # - ignore what you have in handler right now
  # - start writing one model test to handle one case: ie. what should happen when payload is nil?
  # - continue adding model tests and implement functionality in payload handler

# Refactor registration route into registration handler

#### VIEWS

# Write Capybara tests for each of the features on the spec
# Drop down to model level to test relationships and/or custom methods
