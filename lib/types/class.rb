# frozen_string_literal: true

module OneRoster
  module Types
    class Class < Base
      attr_reader :id,
                  :course_id,
                  :provider

      def initialize(attributes = {})
        @id         = attributes['sourcedId']
        @course_id  = attributes['course']['sourcedId']
        @provider   = 'oneroster'
      end
    end
  end
end
