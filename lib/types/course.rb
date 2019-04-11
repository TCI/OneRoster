# frozen_string_literal: true

module OneRoster
  module Types
    class Course < Base
      attr_reader :uid,
                  :course_code,
                  :provider

      def initialize(attributes = {}, *)
        @uid          = attributes['sourcedId']
        @course_code  = attributes['courseCode']
        @provider     = 'oneroster'
      end
    end
  end
end
