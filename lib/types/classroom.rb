# frozen_string_literal: true

module OneRoster
  module Types
    class Classroom < Base
      attr_reader :uid,
                  :name,
                  :course_number,
                  :period,
                  :grades,
                  :provider

      def initialize(attributes = {})
        @uid           = attributes['id']
        @name          = attributes['name']
        @course_number = attributes['course_number']
        @period        = attributes['period']
        @grades        = attributes['grades']
        @provider      = 'oneroster'
      end
    end
  end
end
