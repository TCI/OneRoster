# frozen_string_literal: true
require 'faraday/oauth'

module OneRoster
  class Connection
    OPEN_TIMEOUT = 60
    TIMEOUT = 120

    def initialize(client, oauth_strategy = 'oauth')
      @client = client
      @oauth_strategy = oauth_strategy
    end

    def execute(path, method = :get, params = nil, body = nil, content_type = nil)
      response = Response.new(raw_request(path, method, params, body, content_type))

      if [502, 504].include?(response.status)
        log_to_sentry(
          'client.app_id' => @client.app_id,
          'connection.path' => path,
          'connection.method' => method,
          'connection.params' => params,
          'connection.body' => body,
          'connection.content_type' => content_type,
          'response.http_status' => response.status,
          'response.raw_body' => response.raw_body
        )
        raise GatewayTimeoutError if response.timed_out?
      end

      response
    end

    def set_auth_headers(token, cookie)
      # connection.authorization :Bearer, token
      connection.headers['Authorization'] = "Bearer #{token}"
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

    def raw_request(path, method, params, body, content_type = nil)
      p "request #{path} #{params}"

      connection.public_send(method) do |request|
        request.options.open_timeout     = OPEN_TIMEOUT
        request.options.timeout          = TIMEOUT
        request.url path, params
        request.headers['Content-Type']  = content_type || set_content_type
        request.headers['Cookie']        = @cookie
        request.body                     = render_body(body, content_type)
      end
    end

    def set_content_type
      return 'application/x-www-form-urlencoded' if @client.roster_app == 'synergy'

      'application/json'
    end

    def render_body(body, content_type)
      return URI.encode_www_form(body) if should_encode_body?(body, content_type)

      body
    end

    def should_encode_body?(body, content_type)
      return false if body.nil?

      @client.roster_app == 'synergy' || content_type == 'application/x-www-form-urlencoded'
    end

    def oauth_connection
      Faraday.new(@client.api_url) do |connection|
        connection.request :oauth,
                           consumer_key: @client.app_id,
                           consumer_secret: @client.app_secret
        connection.response :json, content_type: /\bjson$/
        connection.response :logger, @client.logger if @client.logger
        connection.adapter Faraday.default_adapter
      end
    end

    def oauth2_connection
      Faraday.new(@client.api_url) do |connection|
        connection.request :json
        connection.request :authorization, :basic,
                                @client.app_id, @client.app_secret

        connection.response :logger, @client.logger if @client.logger
        connection.response :json, content_type: /\bjson$/
        connection.adapter Faraday.default_adapter
      end
    end

    def log_to_sentry(payload)
      return unless @client.sentry_client

      @client.sentry_client.capture_message(
        'Exception in OneRoster::Connection',
        **{ extra: payload }
      )
    end

    class GatewayTimeoutError < StandardError; end
  end
end
