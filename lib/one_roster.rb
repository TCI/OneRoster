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
require 'types/admin'
require 'types/school'

module OneRoster
  class DistrictNotFound < StandardError; end
  class ConnectionError < StandardError; end

  STUDENTS_ENDPOINT          = 'ims/oneroster/v1p1/students'
  TEACHERS_ENDPOINT          = 'ims/oneroster/v1p1/teachers'
  ADMINS_ENDPOINT            = "ims/oneroster/v1p1/users?filter=role='administrator'"
  COURSES_ENDPOINT           = 'ims/oneroster/v1p1/courses'
  CLASSES_ENDPOINT           = 'ims/oneroster/v1p1/classes'
  ENROLLMENTS_ENDPOINT       = 'ims/oneroster/v1p1/enrollments'
  ACADEMIC_SESSIONS_ENDPOINT = 'ims/oneroster/v1p1/academicSessions'
  SCHOOLS_ENDPOINT           = 'ims/oneroster/v1p1/schools'

  RESPONSE_TYPE_MAP = {
    'users'            => 'users',
    'teachers'         => 'users',
    'students'         => 'users',
    'academicSessions' => 'academicSessions',
    'courses'          => 'courses',
    'classes'          => 'classes',
    'enrollments'      => 'enrollments',
    'schools'          => 'orgs'
  }.freeze
end
