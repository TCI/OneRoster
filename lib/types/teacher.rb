# frozen_string_literal: true

module OneRoster
  module Types
    class Teacher < Base
      attr_reader :id,
                  :email,
                  :first_name,
                  :last_name,
                  :provider,
                  :status

      def initialize(attributes = {})
        @id         = attributes['sourcedId']
        @email      = attributes['email']
        @first_name = attributes['givenName']
        @last_name  = attributes['familyName']
        @status     = attributes['status']
        @provider   = 'oneroster'
      end
    end
  end
end
