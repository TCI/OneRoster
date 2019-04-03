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
    before { client.connection.expects(:execute).with(endpoint, :get, limit: 1).returns(auth_response) }

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

  xdescribe 'students' do

  end

  describe 'teachers' do
    before do
      client.connection.expects(:execute)
        .with(endpoint, :get, limit: 1)
        .returns(auth_response)
      client.connection.expects(:execute)
        .with(endpoint, :get, limit: OneRoster::PAGE_LIMIT, offset: 0)
        .returns(teachers_response)
    end

    it 'authenticates and returns active teachers' do
      response = client.teachers
      expect(client.authenticated).to be(true)

      first_teacher = response[0]
      second_teacher = response[1]

      expect(first_teacher).to be_a(OneRoster::Types::Teacher)
      expect(first_teacher.id).to eq(teacher_1['sourcedId'])
      expect(first_teacher.email).to eq(teacher_1['email'])
      expect(first_teacher.first_name).to eq(teacher_1['givenName'])
      expect(first_teacher.last_name).to eq(teacher_1['familyName'])
      expect(first_teacher.status).to eq(teacher_1['status'])

      expect(second_teacher).to be_a(OneRoster::Types::Teacher)
      expect(second_teacher.id).to eq(teacher_3['sourcedId'])
      expect(second_teacher.email).to eq(teacher_3['email'])
      expect(second_teacher.first_name).to eq(teacher_3['givenName'])
      expect(second_teacher.last_name).to eq(teacher_3['familyName'])
      expect(second_teacher.status).to eq(teacher_3['status'])
    end
  end
end
