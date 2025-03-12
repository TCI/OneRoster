# frozen_string_literal: true

module OneRoster
  module Types
    class Enrollment < Base
      attr_reader :uid,
                  :classroom_uid,
                  :user_uid,
                  :role,
                  :provider,
                  :begin_date,
                  :end_date

      def initialize(attributes = {}, client: nil)
        @uid           = attributes['sourcedId']
        # allow instantiation with classroom_uid and user_uid attrs for consistency with clever
        @classroom_uid = attributes['classroom_uid'] || attributes.dig('class', 'sourcedId')
        @user_uid      = attributes['user_uid'] || attributes.dig('user', 'sourcedId')
        @role          = attributes['role']
        @primary       = attributes['primary']
        @begin_date    = presence(attributes['beginDate'])
        @end_date      = presence(attributes['endDate'])
        @client        = client
        @provider      = 'oneroster'
      end

      def valid?
        return true if student?

        teacher?
      end

      def primary
        teacher? && @primary.to_s == 'true'
      end

      def teacher?
        @role == 'teacher'
      end

      def student?
        @role == 'student'
      end

      def in_term?
        return true unless @client&.only_provision_current_terms
        return true if begin_date.nil? && end_date.nil?
        return Time.parse(begin_date) < Time.now if !begin_date.nil? && end_date.nil?
        return Time.parse(end_date) > Time.now if !end_date.nil? && begin_date.nil?

        Time.parse(begin_date) <= Time.now && Time.parse(end_date) >= Time.now
      end

      def to_h
        {
          classroom_uid: @classroom_uid,
          user_uid: @user_uid,
          primary: primary,
          provider: @provider
        }
      end

      def presence(value)
        value unless value.respond_to?(:empty?) && value.empty?
      end
    end
  end
end
