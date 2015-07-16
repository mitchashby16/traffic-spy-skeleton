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

      if not_registered?(identifier)
        status 403
        body "Application Not Registered - 403 Forbidden"
      elsif missing_payload?
        status 400
        body "Missing Payload - 400 Bad Request"
      elsif duplicate_payload?(parse_payload(params))
        status 403
        body "Already Received Request - 403 Forbidden"
      else
        save_data(identifier, parse_payload(params))

        status 200
        body "Success"
      end

    end

    private

    def not_registered?(identifier)
      !Registration.exists?(identifier: identifier)
    end

    def missing_payload?
      params[:payload].nil?
    end

    def duplicate_payload?(input)
      Payload.exists?(payload_sha: create_unique_payload_identifier(input))
    end

    def parse_payload(input)
      convert_keys_to_symbols(convert_keys_to_snakecase(payload_to_string(input)))
    end

    def payload_to_string(input)
      JSON.parse(input[:payload])
    end

    def convert_keys_to_symbols(hash_with_string_keys)
      hash_with_string_keys.reduce({}) do |symbolized, (k, v)|
        symbolized[k.to_sym] = v;
        symbolized
      end
    end

    def convert_keys_to_snakecase(hash_with_camel_case_keys)
      hash_with_camel_case_keys.reduce({}) do |snaked, (k, v)|
        snaked[snake_case(k)] = v
        snaked
      end
    end

    def snake_case(string)
      string.split(/(?=[A-Z])/).map do |word|
        word.downcase
      end.join("_")
    end

    def pull_out_url_data(data)
      data.select { |k, v| k.eql?(:url) }
    end

    def create_unique_payload_identifier(cleaned_params)
      payload_sha(cleaned_params.to_s)
    end

    def payload_sha(seed)
      Digest::SHA1.hexdigest(seed)
    end

    def save_data(identifier, parsed_payload)
      save_url(identifier, parsed_payload)
      save_payload_unique_identifier(identifier, parsed_payload)
    end

    def save_payload_unique_identifier(identifier, parsed_payload)
      current_payload(identifier).update(payload_sha: create_unique_payload_identifier(parsed_payload))
    end

    def save_url(identifier, parsed_payload)
      current_registration(identifier).urls.create(pull_out_url_data(parsed_payload))
    end

    def current_registration(identifier)
      Registration.find_by(identifier: identifier)
    end

    def current_payload(identifier)
      current_registration(identifier).payloads.last
    end

  end

end
