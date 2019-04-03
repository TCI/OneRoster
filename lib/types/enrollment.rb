# frozen_string_literal: true

module OneRoster
  module Types
    class Enrollment < Base
      attr_reader :id,
                  :classroom_id,
                  :user_id,
                  :role,
                  :provider

      def initialize(attributes = {})
        @id           = attributes['sourcedId']
        @classroom_id = attributes['class']['sourcedId']
        @user_id      = attributes['user']['sourcedId']
        @role         = attributes['role']
        @primary      = attributes['primary']
        @provider     = 'oneroster'
      end

      def valid?
        student? || primary_teacher?
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
    end
  end
end
