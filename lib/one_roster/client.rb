# frozen_string_literal: true

module OneRoster
  class Client
    attr_accessor :app_id, :api_url, :app_secret, :logger, :vendor_key,
                  :shared_classes

    attr_reader :authenticated

    def initialize
      @authenticated = false
    end

    def self.configure
      client = new
      yield(client) if block_given?
      client
    end

    %i[teachers students].each do |record_type|
      define_method(record_type) do |record_ids = []|
        authenticate unless @authenticated

        endpoint = OneRoster.const_get("#{record_type.upcase}_ENDPOINT")
        type = Types.const_get(record_type.to_s.capitalize[0..-2])

        records = Paginator.fetch(connection, endpoint, :get, type).force

        return records if record_ids.empty?

        records.reject { |record| record_ids.exclude?(record.id) }
      end
    end

    def authenticate
      response = connection.execute(TEACHERS_ENDPOINT, :get, limit: 1)

      raise ConnectionError unless response.success?

      @authenticated = true
    end

    def authenticated?
      @authenticated
    end

    def connection
      @connection ||= Connection.new(self)
    end
  end
end
