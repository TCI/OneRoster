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
                  :subjects,
                  :term_id,
                  :school_uid

      def initialize(attributes = {}, *)
        @uid        = attributes['sourcedId']
        @title      = capitalize(attributes['title'])
        @course_uid = attributes['course']['sourcedId']
        @status     = attributes['status']
        @period     = first_period(attributes) || period_from_code(attributes)
        @grades     = presence(attributes['grades']) || []
        @subjects   = presence(attributes['subjects']) || []
        @term_id    = attributes.dig('terms')&.map { |term| term['sourcedId'] } || []
        @school_uid = attributes.dig('school', 'sourcedId')
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
