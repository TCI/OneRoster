# frozen_string_literal: true

module OneRoster
  module Types
    class Enrollment < Base
      attr_reader :uid,
                  :classroom_uid,
                  :user_uid,
                  :role,
                  :provider

      def initialize(attributes = {}, *)
        @uid           = attributes['sourcedId']
        # allow instantiation with classroom_uid and user_uid attrs for consistency with clever
        @classroom_uid = attributes['classroom_uid'] || attributes.dig('class', 'sourcedId')
        @user_uid      = attributes['user_uid'] || attributes.dig('user', 'sourcedId')
        @role          = attributes['role']
        @primary       = attributes['primary']
        @provider      = 'oneroster'
      end

      def valid?(shared_classes)
        return true if student?

        return teacher? if shared_classes

        primary_teacher?
      end

      def primary_teacher?
        teacher? && @primary.to_s == 'true'
      end

      def teacher?
        @role == 'teacher'
      end

      def student?
        @role == 'student'
      end

      def to_h
        {
          classroom_uid: @classroom_uid,
          user_uid: @user_uid,
          provider: @provider
        }
      end
    end
  end
end
