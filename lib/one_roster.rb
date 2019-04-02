# frozen_string_literal: true

require 'pry'

require 'faraday'
require 'faraday_middleware'
require 'oauth'
require 'simple_oauth'

require 'one_roster/client'
require 'one_roster/connection'
require 'one_roster/response'
require 'one_roster/version'

require 'types/base'

module OneRoster
  class DistrictNotFound < StandardError; end
  class ConnectionError < StandardError; end

  RESPONSE_TYPE_MAP = {
    'teachers' => 'users',
    'students' => 'users'
  }
end
