# frozen_string_literal: true

module OneRoster
  module Types
    class Course < Base
      attr_reader :id,
                  :course_code,
                  :provider

      def initialize(attributes = {})
        @id          = attributes['sourcedId']
        @course_code = attributes['courseCode']
        @provider    = 'oneroster'
      end
    end
  end
end
