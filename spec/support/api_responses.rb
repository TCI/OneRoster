# frozen_string_literal: true

require 'spec_helper'

RSpec.shared_context 'api responses' do
  let(:app_id) { 'app_id' }
  let(:app_secret) { 'app_secret' }
  let(:api_url) { 'https://bjulez.oneroster.com/' }
  let(:token_url) { 'https://king-ching.oneroster.com/' }
  let(:oauth_strategy) { 'oauth2' }
  let(:status) { 200 }
  let(:username_source) { nil }
  let(:staff_username_source) { nil }
  let(:empty_body) { { 'users' => [] } }

  let(:client) do
    OneRoster::Client.configure do |config|
      config.app_id                = app_id
      config.app_secret            = app_secret
      config.api_url               = api_url
      config.username_source       = username_source
      config.staff_username_source = staff_username_source
    end
  end

  let(:oauth2_client) do
    OneRoster::Client.configure do |config|
      config.app_id                = app_id
      config.app_secret            = app_secret
      config.api_url               = api_url
      config.username_source       = username_source
      config.staff_username_source = staff_username_source
      config.oauth_strategy        = oauth_strategy
    end
  end

  #################################### TEACHERS RESPONSE ####################################
  let(:teacher_1) do
    {
      'sourcedId' => 'teacher_1',
      'email' => 'goodteacher@gmail.com',
      'username' => 'goodteacher',
      'givenName' => 'good',
      'familyName' => 'teacher',
      'junk' => 'data',
      'status' => 'active'
    }
  end

  let(:teacher_2) do
    {
      'sourcedId' => 'teacher_2',
      'email' => 'badteacher@gmail.com',
      'username' => 'badteacher',
      'givenName' => 'bad',
      'familyName' => 'teacher',
      'junk' => 'data',
      'status' => 'tobedeleted'
    }
  end

  let(:teacher_3) do
    {
      'sourcedId' => 'teacher_3',
      'email' => 'avgteacher@gmail.com',
      'givenName' => 'average',
      'familyName' => 'teacher',
      'junk' => 'data',
      'status' => 'active'
    }
  end

  let(:teachers_response_url) { stub(path: OneRoster::TEACHERS_ENDPOINT) }
  let(:teachers_body) { { 'users' => [teacher_1, teacher_2, teacher_3] } }
  let(:teachers_response) do
    OneRoster::Response.new(stub(body: teachers_body, status: status, env: stub(url: teachers_response_url), headers: {}))
  end

  #################################### TERMS RESPONSE ####################################

  let(:term) do
    {
      'sourcedId' => '1',
      'title' => 'term name',
      'startDate' => '2019-08-21',
      'endDate' => '2020-01-10'
    }
  end

  let(:terms_response_url) { stub(path: OneRoster::ACADEMIC_SESSIONS_ENDPOINT) }
  let(:terms_response) {
    OneRoster::Response.new(stub(body: { 'academicSessions' => [term] }, status: status, env: stub(url: terms_response_url), headers: {}))

  }

  ###################################### AUTH RESPONSE ######################################
  let(:auth_response_url) { stub(path: OneRoster::TEACHERS_ENDPOINT) }
  let(:auth_body) { { 'users' => [teacher_1] } }
  let(:oauth2_auth_body) { { 'access_token' => 'sample_code' } }
  let(:auth_response) do
    OneRoster::Response.new(stub(body: auth_body, status: status, env: stub(url: teachers_response_url), headers: {}))
  end

  let(:oauth2_auth_response) do
    OneRoster::Response.new(stub(body: oauth2_auth_body, raw_body: oauth2_auth_body, env: stub(url: teachers_response_url), status: status, headers: {}))
  end

  #################################### STUDENTS RESPONSE ####################################
  let(:student_1) do
    {
      'sourcedId' => 'student_1',
      'givenName' => 'good',
      'familyName' => 'student',
      'username' => '',
      'email' => '',
      'status' => 'active',
      'junk' => 'data'
    }
  end

  let(:student_2) do
    {
      'sourcedId' => 'student_2',
      'givenName' => 'bad',
      'familyName' => 'student',
      'username' => 'trashkid',
      'email' => 'bad@school.com',
      'status' => 'tobedeleted',
      'junk' => 'data'
    }
  end

  let(:student_3) do
    {
      'sourcedId' => 'student_3',
      'givenName' => 'average',
      'familyName' => 'student',
      'username' => '',
      'email' => 'meh@school.com',
      'status' => 'active',
      'junk' => 'data'
    }
  end

  let(:student_4) do
    {
      'sourcedId' => '',
      'givenName' => 'best',
      'familyName' => 'student',
      'username' => 'bestkid1',
      'email' => 'best@school.com',
      'status' => 'active',
      'junk' => 'data'
    }
  end

  let(:students_response_url) { stub(path: OneRoster::STUDENTS_ENDPOINT) }
  let(:students_body) { { 'users' => [student_1, student_2, student_3, student_4] } }
  let(:students_response) do
    OneRoster::Response.new(stub(body: students_body, status: status, env: stub(url: students_response_url), headers: {}))
  end

  ################################### ENROLLMENTS RESPONSE ##################################
  # enrollment_1: teacher_1 (primary)     in class 1 => valid
  # enrollment_2: student_1 (tobedeleted) in class_1 => invalid
  # enrollment_3: teacher_3 (not primary) in class_1 => invalid
  # enrollment_4: teacher_1 (primary)     in class_2 => valid
  # enrollment_5: student_2 (tobedeleted) in class_2 => invalid
  # enrollment_6: student_3               in class_2 => valid

  let(:enrollment_1) do
    {
      'sourcedId' => 'enrollment_1',
      'class' => { 'sourcedId' => class_1['sourcedId'] },
      'user' => { 'sourcedId' => teacher_1['sourcedId'] },
      'role' => 'teacher',
      'primary' => true,
      'junk' => 'data'
    }
  end

  let(:enrollment_2) do
    {
      'sourcedId' => 'enrollment_2',
      'class' => { 'sourcedId' => class_1['sourcedId'] },
      'user' => { 'sourcedId' => student_1['sourcedId'] },
      'role' => 'student',
      'status' => 'tobedeleted',
      'junk' => 'data'
    }
  end

  let(:enrollment_3) do
    {
      'sourcedId' => 'enrollment_3',
      'class' => { 'sourcedId' => class_1['sourcedId'] },
      'user' => { 'sourcedId' => teacher_3['sourcedId'] },
      'role' => 'teacher',
      'primary' => 'false',
      'junk' => 'data'
    }
  end

  let(:enrollment_4) do
    {
      'sourcedId' => 'enrollment_4',
      'class' => { 'sourcedId' => class_2['sourcedId'] },
      'user' => { 'sourcedId' => teacher_1['sourcedId'] },
      'role' => 'teacher',
      'primary' => 'true',
      'junk' => 'data'
    }
  end

  let(:enrollment_5) do
    {
      'sourcedId' => 'enrollment_5',
      'class' => { 'sourcedId' => class_2['sourcedId'] },
      'user' => { 'sourcedId' => student_2['sourcedId'] },
      'role' => 'student',
      'status' => 'tobedeleted',
      'primary' => 'true',
      'junk' => 'data'
    }
  end

  let(:enrollment_6) do
    {
      'sourcedId' => 'enrollment_6',
      'class' => { 'sourcedId' => class_2['sourcedId'] },
      'user' => { 'sourcedId' => student_3['sourcedId'] },
      'role' => 'student',
      'junk' => 'data'
    }
  end

  let(:enrollments_response_url) { stub(path: OneRoster::ENROLLMENTS_ENDPOINT) }
  let(:enrollments_body) do
    { 'enrollments' => [enrollment_1, enrollment_2, enrollment_3, enrollment_4, enrollment_5, enrollment_6] }
  end
  let(:enrollments_response) do
    OneRoster::Response.new(stub(body: enrollments_body, status: status, env: stub(url: enrollments_response_url), headers: {}))
  end

  #################################### CLASSES RESPONSE #####################################
  let(:class_1) do
    {
      'sourcedId' => 'class_1',
      'course' => { 'sourcedId' => course_1['sourcedId'] },
      'status' => 'active',
      'title' => 'SOC STUDIES 3 - B. julez',
      'periods' => %w(1 2),
      'grades' => %w(04 05),
      'junk' => 'data',
      'terms' => [{ 'sourcedId' => '1' }]
    }
  end

  let(:class_2) do
    {
      'sourcedId' => 'class_2',
      'course' => { 'sourcedId' => course_2['sourcedId'] },
      'status' => 'tobedeleted',
      'title' => 'PROGRAMMING',
      'periods' => ['PROGRAMMING - Period 2 - Julius'],
      'grades' => %w(06),
      'subjects' => 'object oriented concepts',
      'junk' => 'data',
      'terms' => [{ 'sourcedId' => '1' }]
    }
  end

  let(:class_3) do
    {
      'sourcedId' => 'class_3',
      'course' => { 'sourcedId' => course_3['sourcedId'] },
      'status' => 'active',
      'title' => 'meme studies 3 - b. julez',
      'classCode' => 'meme studies 3 - Period 3 - Julius',
      'grades' => %w(01 02 03),
      'subjects' => ['memes', 'lulz'],
      'junk' => 'data',
      'terms' => [{ 'sourcedId' => '1' }]
    }
  end

  let(:class_4) do
    {
      'sourcedId' => 'class_4',
      'course' => { 'sourcedId' => 'veryfakecourseid' },
      'status' => 'active',
      'title' => 'PROGRAMMING',
      'periods' => ['4'],
      'grades' => %w(06),
      'junk' => 'data',
      'terms' => [{ 'sourcedId' => '1' }]
    }
  end

  let(:classes_response_url) { stub(path: OneRoster::CLASSES_ENDPOINT) }
  let(:classes_body) { { 'classes' => [class_1, class_2, class_3, class_4] } }
  let(:classes_response) do
    OneRoster::Response.new(stub(body: classes_body, status: status, env: stub(url: classes_response_url), headers: {}))
  end

  #################################### COURSES RESPONSE #####################################
  let(:course_1) do
    {
      'sourcedId' => 'course_1',
      'courseCode' => 'code_1',
      'junk' => 'data'
    }
  end

  let(:course_2) do
    {
      'sourcedId' => 'course_2',
      'courseCode' => 'code_2',
      'junk' => 'data'
    }
  end

  let(:course_3) do
    {
      'sourcedId' => 'course_3',
      'courseCode' => 'code_3',
      'junk' => 'data'
    }
  end

  let(:course_4) do
    {
      'sourcedId' => 'course_4',
      'courseCode' => 'code_4',
      'junk' => 'data'
    }
  end

  let(:courses_response_url) { stub(path: OneRoster::COURSES_ENDPOINT) }
  let(:courses_body) { { 'courses' => [course_1, course_2, course_3, course_4] } }
  let(:courses_response) do
    OneRoster::Response.new(stub(body: courses_body, status: status, env: stub(url: courses_response_url), headers: {}))
  end

  ################################### PAGINATION RESPONSE ###################################
  let(:page_1_response) do
    OneRoster::Response.new(
      stub(
        body: { 'enrollments' => [enrollment_1, enrollment_2] },
        status: 200,
        env: stub(url: enrollments_response_url),
        headers: {}
      )
    )
  end

  let(:page_2_response) do
    OneRoster::Response.new(
      stub(
        body: { 'enrollments' => [enrollment_3, enrollment_4] },
        status: 200,
        env: stub(url: enrollments_response_url),
        headers: {}
      )
    )
  end

  let(:page_3_response) do
    OneRoster::Response.new(
      stub(
        body: { 'enrollments' => [enrollment_5] },
        status: 200,
        env: stub(url: enrollments_response_url),
        headers: {}
      )
    )
  end

  let(:empty_response) do
    OneRoster::Response.new(
      stub(
        body: { 'enrollments' => [] },
        status: 200,
        env: stub(url: enrollments_response_url),
        headers: {}
      )
    )
  end
end
