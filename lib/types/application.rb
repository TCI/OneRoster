module OneRoster
  module Types
    class Application < Base
      attr_reader :uid,
                  :bearer,
                  :name,
                  :tenant_name,
                  :app_id

      def initialize(attributes = {}, *)
        @uid         = attributes['id']
        @bearer      = attributes['bearer']
        @name        = attributes['name']
        @tenant_name = attributes['tenant_name']
        @app_id      = attributes['oneroster_application_id']
      end
    end
  end
end
