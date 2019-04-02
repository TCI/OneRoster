# frozen_string_literal: true

RSpec.shared_context 'api responses' do
  let(:something) { 'something' }
  let(:auth_body) do
    {
      'users' => [
        'sourcedId' => '12345',
        'email' => '',
        'givenName' => '',
        'familyName' => ''
      ]
    }
  end
end
