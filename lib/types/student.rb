# frozen_string_literal: true

module OneRoster
  module Types
    class Student < Base
      attr_reader :id,
                  :first_name,
                  :last_name,
                  :username,
                  :status,
                  :provider

      def initialize(attributes = {})
        @id         = attributes['sourcedId']
        @first_name = attributes['givenName']
        @last_name  = attributes['familyName']
        @username   = attributes['username']
        @status     = attributes['status']
        @provider   = 'oneroster'
      end
    end
  end
end
