# frozen_string_literal: true

module OneRoster
  module Types
    class Class < Base
      attr_reader :uid,
                  :title,
                  :course_uid,
                  :provider,
                  :period,
                  :grades,
                  :subject,
                  :term_id

      def initialize(attributes = {}, *)
        @uid        = attributes['sourcedId']
        @title      = capitalize(attributes['title'])
        @course_uid = attributes['course']['sourcedId']
        @status     = attributes['status']
        @period     = first_period(attributes) || period_from_code(attributes)
        @grades     = attributes['grades']
        @subject    = presence(attributes['subjects']) || []
        @term_id    = attributes['terms'][0]['sourcedId']
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

      def presence(field)
        field unless blank?(field)
      end

      def blank?(field)
        field.nil? || field == ''
      end
    end
  end
end
