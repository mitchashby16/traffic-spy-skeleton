require_relative '../test_helper'

class IdentifierDataPathTest < ControllerTest
  attr_reader :registered_user_id

  def setup
    super
    @registered_user_id = "user_id"
    register_user(@registered_user_id)

  end

  def test_return_403_when_identifier_not_registered
    post '/sources/identifier_not_in_database/data', 'who cares'

    assert_equal 403, last_response.status
    assert_equal 'Application Not Registered - 403 Forbidden', last_response.body
  end

  def test_return_400_when_the_payload_is_missing
    post "/sources/#{registered_user_id}/data", nil

    assert_equal 400, last_response.status
    assert_equal "Missing Payload - 400 Bad Request", last_response.body
  end

  def test_url_is_saved_on_successful_request
    post "/sources/#{registered_user_id}/data", @post_request_body

    assert_equal "http://jumpstartlab.com/blog", Url.all.first.url
  end

  def test_return_200_when_successful_request
    post "/sources/#{registered_user_id}/data", @post_request_body

    assert_equal false, Payload.first[:payload_sha].nil?
  end

  def test_unique_payload_identifier_saved_on_good_request
    post "/sources/#{registered_user_id}/data", @post_request_body

    assert_equal 200, last_response.status
    assert_equal "Success", last_response.body
  end

  def test_return_403_when_duplicate_payload
    post "/sources/#{registered_user_id}/data", @post_request_body
    post "/sources/#{registered_user_id}/data", @post_request_body

    assert_equal 403, last_response.status
    assert_equal "Already Received Request - 403 Forbidden", last_response.body
  end


  private

  def register_user(identifier)
    post '/sources', { "identifier" => identifier, "rootUrl" => "http://facebook.com" }
  end

end
