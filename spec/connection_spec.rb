# frozen_string_literal: true

require 'spec_helper'

RSpec.describe OneRoster::Connection do
  let(:connection) { described_class.new(client) }
  let(:logger) { stub('Logger') }
  let(:app_id) { 'app_id' }
  let(:app_secret) { 'app_secret' }
  let(:api_url) { 'https://bjulez.oneroster.com/' }

  let(:client) do
    OneRoster::Client.configure do |config|
      config.app_id     = app_id
      config.app_secret = app_secret
      config.api_url    = api_url
      config.logger     = logger
    end
  end

  describe '#connection' do
    it 'returns new faraday connection if one does not exist' do
      conn = connection.connection
      expect(conn).to be_a(Faraday::Connection)
      expect(conn.headers).to eq('User-Agent' => "Faraday v#{Faraday::VERSION}")
      expect(conn.builder.handlers).to eq(
        [
          FaradayMiddleware::OAuth, Faraday::Response::Logger,
          FaradayMiddleware::ParseJson, Faraday::Adapter::NetHttp
        ]
      )
    end

    it 'memoizes the connection' do
      conn = connection.connection
      expect(connection.connection).to eq(conn)
    end
  end

  describe '#execute' do
    let(:status) { 200 }
    let(:body) { 'body' }
    let(:env) { stub(url: stub(path: '/enrollments')) }
    let(:mock_response) { stub(status: status, body: body, env: env) }

    context 'successful response' do
      it 'returns a successful response object' do
        connection.expects(:connection).returns(OneRoster::MockFaradayConnection.new(mock_response))
        response = connection.execute('/enrollments', :get, limit: OneRoster::PAGE_LIMIT, offset: 0)
        expect(response).to be_a(OneRoster::Response)
        expect(response.success?).to be(true)
        expect(response.raw_body).to eq(mock_response.body)
      end
    end

    context 'failed response' do
      let(:status) { 401 }
      let(:body) { 'unauthorized' }

      it 'returns a failed response object' do
        connection.stubs(:raw_request).returns(mock_response)
        response = connection.execute('/teachers', :get, limit: OneRoster::PAGE_LIMIT, offset: 0)
        expect(response).to be_a(OneRoster::Response)
        expect(response.success?).to be(false)
        expect(response.raw_body).to eq(mock_response.body)
      end
    end
  end

  describe '#log' do
    it 'logs properly' do
      logger.expects(:info)

      connection.log('💩')
    end
  end
end
