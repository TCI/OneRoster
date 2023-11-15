module OneRoster
  module Types
    class Admin < Teacher
      def initialize(attributes = {}, *, options)
        @uid          = attributes['sourcedId']
        @email        = attributes['email']
        @first_name   = attributes['givenName']
        @last_name    = attributes['familyName']
        @api_username = attributes['username']
        @username     = username(options[:client])
        @provider     = 'oneroster'
        @role         = 'admin'
      end
    end
  end
end
