# frozen_string_literal: true

module OneRoster
  module Types
    class Enrollment < Base
      attr_reader :id,
                  :classroom_id,
                  :user_id,
                  :provider

      def initialize(attributes = {})
        @id           = attributes['sourcedId']
        @classroom_id = attributes['class']['sourcedId']
        @user_id      = attributes['user']['sourcedId']
        @provider     = 'oneroster'
      end
    end
  end
end
