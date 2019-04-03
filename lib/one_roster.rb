# frozen_string_literal: true

require 'pry'

require 'faraday'
require 'faraday_middleware'
require 'oauth'
require 'simple_oauth'

require 'one_roster/client'
require 'one_roster/connection'
require 'one_roster/paginator'
require 'one_roster/response'
require 'one_roster/version'

require 'types/base'
require 'types/student'
require 'types/teacher'

module OneRoster
  class DistrictNotFound < StandardError; end
  class ConnectionError < StandardError; end

  STUDENTS_ENDPOINT = 'ims/oneroster/v1p1/students'
  TEACHERS_ENDPOINT = 'ims/oneroster/v1p1/teachers'

  RESPONSE_TYPE_MAP = {
    'teachers' => 'users',
    'students' => 'users'
  }.freeze
end
