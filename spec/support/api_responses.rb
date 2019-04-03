# frozen_string_literal: true

RSpec.shared_context 'api responses' do
  #################################### TEACHERS RESPONSE ####################################
  let(:teacher_1) do
    {
      'sourcedId' => '1',
      'email' => 'goodteacher@gmail.com',
      'givenName' => 'good',
      'familyName' => 'teacher',
      'junk' => 'data',
      'status' => 'active'
    }
  end

  let(:teacher_2) do
    {
      'sourcedId' => '2',
      'email' => 'badteacher@gmail.com',
      'givenName' => 'bad',
      'familyName' => 'teacher',
      'junk' => 'data',
      'status' => 'tobedeleted'
    }
  end

  let(:teacher_3) do
    {
      'sourcedId' => '2',
      'email' => 'avgteacher@gmail.com',
      'givenName' => 'average',
      'familyName' => 'teacher',
      'junk' => 'data',
      'status' => 'active'
    }
  end

  let(:teachers_body) { { 'users' => [teacher_1, teacher_2, teacher_3] } }
  let(:teachers_response) do
    OneRoster::Response.new(stub(body: teachers_body, status: status, env: response_env))
  end

  ###################################### AUTH RESPONSE ######################################
  let(:auth_body) { { 'users' => [teacher_1] } }
  let(:auth_response) do
    OneRoster::Response.new(stub(body: auth_body, status: status, env: response_env))
  end
end
