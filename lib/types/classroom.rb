# frozen_string_literal: true

module OneRoster
  module Types
    class Classroom < Base
      attr_reader :uid,
                  :name,
                  :course_number,
                  :period,
                  :grades,
                  :subjects,
                  :provider,
                  :term_name,
                  :term_start_date,
                  :term_end_date,
                  :term_id

      def initialize(attributes = {})
        @uid             = attributes['id']
        @name            = attributes['name']
        @course_number   = attributes['course_number']
        @period          = attributes['period']
        @grades          = attributes['grades']
        @subjects        = attributes['subjects']
        @term_name       = attributes['term_name']
        @term_start_date = attributes['term_start_date']
        @term_end_date   = attributes['term_end_date']
        @term_id         = attributes['term_id']
        @provider        = 'oneroster'
      end
    end
  end
end
