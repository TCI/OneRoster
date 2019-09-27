# frozen_string_literal: true

module OneRoster
  class Connection
    OPEN_TIMEOUT = 60
    TIMEOUT = 120

    def initialize(client, oauth_strategy = 'oauth')
      @client = client
      @oauth_strategy = oauth_strategy
    end

    def execute(path, method = :get, params = nil, body = nil)
      Response.new(raw_request(path, method, params, body))
    end

    def set_auth_headers(token, cookie)
      connection.authorization :Bearer, token
      @cookie = cookie
    end

    def connection
      return @connection if @connection

      @connection = if @oauth_strategy == 'oauth2'
                      oauth2_connection
                    else
                      oauth_connection
                    end
    end

    def log(message = '')
      return unless @client.logger

      @client.logger.info message
    end

    private

    def raw_request(path, method, params, body)
      p "request #{path} #{params}"

      connection.public_send(method) do |request|
        request.options.open_timeout     = OPEN_TIMEOUT
        request.options.timeout          = TIMEOUT
        request.url path, params
        request.headers['Accept-Header'] = 'application/json'
        request.headers['Cookie']        = @cookie
        request.body                     = body
      end
    end

    def oauth_connection
      Faraday.new(@client.api_url) do |connection|
        connection.request :oauth,
                           consumer_key: @client.app_id,
                           consumer_secret: @client.app_secret
        connection.response :logger, @client.logger if @client.logger
        connection.response :json, content_type: /\bjson$/
        connection.adapter Faraday.default_adapter
      end
    end

    def oauth2_connection
      connection = Faraday.new(@client.api_url) do |connection|
        connection.request :json
        connection.response :logger, @client.logger if @client.logger
        connection.response :json, content_type: /\bjson$/
        connection.adapter Faraday.default_adapter
      end
      connection.basic_auth(@client.app_id, @client.app_secret)
      connection
    end
  end
end
