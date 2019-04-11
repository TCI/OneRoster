# frozen_string_literal: true

module OneRoster
  module Types
    class Class < Base
      attr_reader :uid,
                  :title,
                  :course_uid,
                  :provider,
                  :period,
                  :grades

      def initialize(attributes = {}, *)
        @uid        = attributes['sourcedId']
        @title      = capitalize(attributes['title'])
        @course_uid = attributes['course']['sourcedId']
        @status     = attributes['status']
        @period     = first_period(attributes) || period_from_code(attributes)
        @grades     = attributes['grades']
        @provider   = 'oneroster'
      end

      private

      def capitalize(string)
        string.split(' ').map(&:capitalize).join(' ')
      end

      def first_period(attributes)
        attributes['periods']&.first
      end

      def period_from_code(attributes)
        attributes['classCode']&.match(/- Period (\d+) -/) { |m| m[1] }
      end
    end
  end
end
