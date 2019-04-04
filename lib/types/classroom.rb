# frozen_string_literal: true

module OneRoster
  module Types
    class Classroom < Base
      attr_reader :id,
                  :name,
                  :course_number,
                  :period,
                  :grades,
                  :provider

      def initialize(course, oneroster_class)
        @id            = oneroster_class.id
        @name          = oneroster_class.title
        # @course_number = course&.course_code || oneroster_class.course_id
        @course_number = course.course_code
        @period        = oneroster_class.period
        @grades        = oneroster_class.grades
        @provider      = 'oneroster'
      end
    end
  end
end
