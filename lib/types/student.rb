# frozen_string_literal: true

module OneRoster
  module Types
    class Student < Base
      attr_reader :uid,
                  :first_name,
                  :last_name,
                  :username,
                  :provider

      def initialize(attributes = {})
        @uid        = attributes['sourcedId']
        @first_name = attributes['givenName']
        @last_name  = attributes['familyName']
        @username   = attributes['username']
        @status     = attributes['status']
        @provider   = 'oneroster'
      end
    end
  end
end
