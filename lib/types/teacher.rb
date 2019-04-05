# frozen_string_literal: true

module OneRoster
  module Types
    class Teacher < Base
      attr_reader :uid,
                  :email,
                  :first_name,
                  :last_name,
                  :provider

      def initialize(attributes = {})
        @uid        = attributes['sourcedId']
        @email      = attributes['email']
        @first_name = attributes['givenName']
        @last_name  = attributes['familyName']
        @provider   = 'oneroster'
      end
    end
  end
end
