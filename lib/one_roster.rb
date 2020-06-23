# frozen_string_literal: true

require 'pry'

require 'dry/inflector'
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
require 'types/course'
require 'types/class'
require 'types/classroom'
require 'types/enrollment'
require 'types/student'
require 'types/teacher'
require 'types/term'

module OneRoster
  class DistrictNotFound < StandardError; end
  class ConnectionError < StandardError; end

  STUDENTS_ENDPOINT          = 'ims/oneroster/v1p1/students'
  TEACHERS_ENDPOINT          = 'ims/oneroster/v1p1/teachers'
  COURSES_ENDPOINT           = 'ims/oneroster/v1p1/courses'
  CLASSES_ENDPOINT           = 'ims/oneroster/v1p1/classes'
  ENROLLMENTS_ENDPOINT       = 'ims/oneroster/v1p1/enrollments'
  ACADEMIC_SESSIONS_ENDPOINT = 'ims/oneroster/v1p1/academicSessions'

  RESPONSE_TYPE_MAP = {
    'teachers'     => 'users',
    'academicSessions'        => 'academicSessions',
    'students'     => 'users',
    'courses'      => 'courses',
    'classes'      => 'classes',
    'enrollments'  => 'enrollments'
  }.freeze
end
