# frozen_string_literal: true

require 'spec_helper'

RSpec.describe OneRoster::Client do
  include_context 'api responses'

  let(:app_id) { 'app_id' }
  let(:app_secret) { 'app_secret' }
  let(:api_url) { 'https://bjulez.oneroster.com/' }
  let(:status) { 200 }
  let(:endpoint) { OneRoster::TEACHERS_ENDPOINT }
  let(:response_url) { stub(path: endpoint) }
  let(:response_env) { stub(url: response_url) }

  let(:client) do
    OneRoster::Client.configure do |config|
      config.app_id     = app_id
      config.app_secret = app_secret
      config.api_url    = api_url
    end
  end

  it 'is configurable' do
    expect(client).to be_a(OneRoster::Client)
    expect(client.app_id).to eq(app_id)
    expect(client.app_secret).to eq(app_secret)
    expect(client.api_url).to eq(api_url)
  end

  describe 'authentication' do
    let(:mock_response) { OneRoster::Response.new(stub(body: auth_body, status: status, env: response_env)) }
    before { client.connection.expects(:execute).with(endpoint, :get, limit: 1).returns(mock_response) }

    context 'successful authentication' do
      it 'sets authenticated status' do
        expect { client.authenticate }
          .to change { client.authenticated }.from(false).to(true)
      end
    end

    context 'connection error' do
      let(:status) { 401 }
      it 'raises error' do
        expect { client.authenticate }.to raise_error(OneRoster::ConnectionError)
      end
    end
  end
end
