# frozen_string_literal: true

RSpec.shared_context 'api responses' do
  #################################### TEACHERS RESPONSE ####################################
  let(:teacher_1) do
    {
      'sourcedId'  => 't1',
      'email'      => 'goodteacher@gmail.com',
      'givenName'  => 'good',
      'familyName' => 'teacher',
      'junk'       => 'data',
      'status'     => 'active'
    }
  end

  let(:teacher_2) do
    {
      'sourcedId'  => 't2',
      'email'      => 'badteacher@gmail.com',
      'givenName'  => 'bad',
      'familyName' => 'teacher',
      'junk'       => 'data',
      'status'     => 'tobedeleted'
    }
  end

  let(:teacher_3) do
    {
      'sourcedId'  => 't3',
      'email'      => 'avgteacher@gmail.com',
      'givenName'  => 'average',
      'familyName' => 'teacher',
      'junk'       => 'data',
      'status'     => 'active'
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

  #################################### STUDENTS RESPONSE ####################################
  let(:student_1) do
    {
      'sourcedId'  => 's1',
      'givenName'  => 'good',
      'familyName' => 'student',
      'username'   => 'coolkid1',
      'status'     => 'active',
      'junk'       => 'data'
    }
  end

  let(:student_2) do
    {
      'sourcedId'  => 's2',
      'givenName'  => 'bad',
      'familyName' => 'student',
      'username'   => 'badkid1',
      'status'     => 'tobedeleted',
      'junk'       => 'data'
    }
  end

  let(:student_3) do
    {
      'sourcedId'  => 's3',
      'givenName'  => 'average',
      'familyName' => 'student',
      'username'   => 'mehkid1',
      'status'     => 'active',
      'junk'       => 'data'
    }
  end

  let(:students_body) { { 'users' => [student_1, student_2, student_3] } }
  let(:students_response) do
    OneRoster::Response.new(stub(body: students_body, status: status, env: response_env))
  end

  ################################### ENROLLMENTS RESPONSE ##################################
  let(:enrollment_1) do
    {
      'sourcedId' => '1',
      'class' => { 'sourcedId' => '1' }, # change to class ID when implementing
      'user' => { 'sourcedId' => teacher_1['sourcedId'] },
      'junk' => 'data'
    }
  end

  let(:enrollment_2) do
    {
      'sourcedId' => '2',
      'class' => { 'sourcedId' => '2' }, # change to class ID when implementing
      'user' => { 'sourcedId' => teacher_2['sourcedId'] },
      'junk' => 'data'
    }
  end

  let(:enrollments_body) { { 'enrollments' => [enrollment_1, enrollment_2] } }
  let(:enrollments_response) do
    OneRoster::Response.new(stub(body: enrollments_body, status: status, env: response_env))
  end
end
