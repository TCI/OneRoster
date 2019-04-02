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

    def authenticate
      response = connection.execute('teachers', :get, limit: 1)

      raise ConnectionError unless response.success?

      @authenticated = true
    end

    def connection
      @connection ||= Connection.new(self)
    end
  end
end
