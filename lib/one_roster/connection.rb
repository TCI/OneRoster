module OneRoster
  class Connection
    OPEN_TIMEOUT = 60
    TIMEOUT = 120

    def initialize(client)
      @client = client
    end

    def execute(path, method = :get, params = nil, body = nil)
      Response.new(raw_request(path, method, params, body))
    end

    private

    def connection
      return @connection if @connection

      @connection = Faraday.new(@client.api_url) do |connection|
        connection.request :oauth,
                           consumer_key: @client.app_id,
                           consumer_secret: @client.app_secret
        connection.response :logger, @client.logger if @client.logger
        connection.response :json, content_type: /\bjson$/
        connection.adapter Faraday.default_adapter
      end
    end

    def raw_request(path, method, params, body)
      p "request #{path} #{params}"

      connection.public_send(method) do |request|
        request.options.open_timeout     = OPEN_TIMEOUT
        request.options.timeout          = TIMEOUT
        request.url path, params
        request.headers['Accept-Header'] = 'application/json'
        request.body                     = body
      end
    end

    def log(msg = '')
      return unless @client.logger
    end
  end
end
