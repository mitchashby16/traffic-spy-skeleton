require_relative '../test_helper'

class SourcesPathTest < FeatureTest
  def test_show_most_requested_to_least_requested_urls
    skip
    registration = create_registration
    create_payloads_for(registration)
    # visit '/'

  end

  private

  def create_registration
    Registration.create(identifier: "turing", root_url: "http://turing.io")
  end

  def create_payloads_for(registration)
    registration.payloads.create(url: Url.create("http://turing.io/blog"))
    # create other URLS here
  end
end

