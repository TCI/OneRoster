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

      def initialize(course, oneroster_class, *)
        @uid           = oneroster_class.uid
        @name          = oneroster_class.title
        @course_number = course.course_code
        @period        = oneroster_class.period
        @grades        = oneroster_class.grades
        @provider      = 'oneroster'
      end
    end
  end
end
