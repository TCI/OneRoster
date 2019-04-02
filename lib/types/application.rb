module OneRoster
  module Types
    class Application < Base
      attr_reader :id,
                  :bearer,
                  :name,
                  :tenant_name,
                  :app_id

      def initialize(attributes = {})
        @id          = attributes['id']
        @bearer      = attributes['bearer']
        @name        = attributes['name']
        @tenant_name = attributes['tenant_name']
        @app_id      = attributes['oneroster_application_id']
      end
    end
  end
end
