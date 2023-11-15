# frozen_string_literal: true

module OneRoster
  module Types
    class Teacher < Base
      attr_reader :uid,
                  :email,
                  :first_name,
                  :last_name,
                  :provider,
                  :role

      def initialize(attributes = {}, *, options)
        @uid          = attributes['sourcedId']
        @email        = attributes['email']
        @first_name   = attributes['givenName']
        @last_name    = attributes['familyName']
        @api_username = attributes['username']
        @username     = username(options[:client])
        @provider     = 'oneroster'
        @role         = 'teacher'
      end

      def username(client = nil)
        username_source = client&.staff_username_source
        @username ||= presence(username_from(username_source))
      end

      def to_h
        {
          uid: @uid,
          email: @email,
          first_name: @first_name,
          last_name: @last_name,
          username: @username,
          provider: @provider
        }
      end

      private

      def presence(field)
        field unless blank?(field)
      end

      def blank?(field)
        field.nil? || field == ''
      end

      def username_from(username_source)
        return unless presence(username_source)

        source = username_source(username_source)

        presence(instance_variable_get("@#{source}"))
      end

      # if the username_source is `sourcedId`, we want to return `uid`
      # so we can grab the right instance variable
      def username_source(source)
        case source
        when 'sourcedId' then 'uid'
        when 'username' then 'api_username'
        else
          source
        end
      end
    end
  end
end
