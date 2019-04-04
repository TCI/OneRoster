# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'simplecov'
SimpleCov.start

require 'bundler/setup'
require 'one_roster'
require 'pry'
require 'support/api_responses'

require './spec/helpers/one_roster/mock_faraday_connection'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.include OneRoster
  # config.include Helpers::Authentication
  config.mock_framework = :mocha
end

def mock_request(endpoint, response)
  client.connection.expects(:execute)
    .with(endpoint, :get, limit: OneRoster::PAGE_LIMIT, offset: 0)
    .returns(response)
end

def mock_authentication
  client.connection.expects(:execute)
    .with(OneRoster::TEACHERS_ENDPOINT, :get, limit: 1)
    .returns(auth_response)
end

def mock_requests(endpoint, response)
  mock_authentication
  client.connection.expects(:execute)
    .with(endpoint, :get, limit: OneRoster::PAGE_LIMIT, offset: 0)
    .returns(response)
end
