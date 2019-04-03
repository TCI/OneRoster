# frozen_string_literal: true

RSpec.shared_context 'api responses' do
  #################################### TEACHERS RESPONSE ####################################
  let(:teacher_1) do
    {
      'sourcedId'  => 'teacher_1',
      'email'      => 'goodteacher@gmail.com',
      'givenName'  => 'good',
      'familyName' => 'teacher',
      'junk'       => 'data',
      'status'     => 'active'
    }
  end

  let(:teacher_2) do
    {
      'sourcedId'  => 'teacher_2',
      'email'      => 'badteacher@gmail.com',
      'givenName'  => 'bad',
      'familyName' => 'teacher',
      'junk'       => 'data',
      'status'     => 'tobedeleted'
    }
  end

  let(:teacher_3) do
    {
      'sourcedId'  => 'teacher_3',
      'email'      => 'avgteacher@gmail.com',
      'givenName'  => 'average',
      'familyName' => 'teacher',
      'junk'       => 'data',
      'status'     => 'active'
    }
  end

  let(:teachers_response_url) { stub(path: OneRoster::TEACHERS_ENDPOINT) }
  let(:teachers_body) { { 'users' => [teacher_1, teacher_2, teacher_3] } }
  let(:teachers_response) do
    OneRoster::Response.new(stub(body: teachers_body, status: status, env: stub(url: teachers_response_url)))
  end

  ###################################### AUTH RESPONSE ######################################
  let(:auth_response_url) { stub(path: OneRoster::TEACHERS_ENDPOINT) }
  let(:auth_body) { { 'users' => [teacher_1] } }
  let(:auth_response) do
    OneRoster::Response.new(stub(body: auth_body, status: status, env: stub(url: teachers_response_url)))
  end

  #################################### STUDENTS RESPONSE ####################################
  let(:student_1) do
    {
      'sourcedId'  => 'student_1',
      'givenName'  => 'good',
      'familyName' => 'student',
      'username'   => 'coolkid1',
      'status'     => 'active',
      'junk'       => 'data'
    }
  end

  let(:student_2) do
    {
      'sourcedId'  => 'student_2',
      'givenName'  => 'bad',
      'familyName' => 'student',
      'username'   => 'badkid1',
      'status'     => 'tobedeleted',
      'junk'       => 'data'
    }
  end

  let(:student_3) do
    {
      'sourcedId'  => 'student_3',
      'givenName'  => 'average',
      'familyName' => 'student',
      'username'   => 'mehkid1',
      'status'     => 'active',
      'junk'       => 'data'
    }
  end

  let(:students_response_url) { stub(path: OneRoster::STUDENTS_ENDPOINT) }
  let(:students_body) { { 'users' => [student_1, student_2, student_3] } }
  let(:students_response) do
    OneRoster::Response.new(stub(body: students_body, status: status, env: stub(url: students_response_url)))
  end

  ################################### ENROLLMENTS RESPONSE ##################################
  let(:enrollment_1) do
    {
      'sourcedId' => 'enrollment_1',
      'class' => { 'sourcedId' => class_1['sourcedId'] },
      'user' => { 'sourcedId' => teacher_1['sourcedId'] },
      'junk' => 'data'
    }
  end

  let(:enrollment_2) do
    {
      'sourcedId' => 'enrollment_2',
      'class' => { 'sourcedId' => class_2['sourcedId'] },
      'user' => { 'sourcedId' => teacher_2['sourcedId'] },
      'junk' => 'data'
    }
  end

  let(:enrollments_response_url) { stub(path: OneRoster::ENROLLMENTS_ENDPOINT) }
  let(:enrollments_body) { { 'enrollments' => [enrollment_1, enrollment_2] } }
  let(:enrollments_response) do
    OneRoster::Response.new(stub(body: enrollments_body, status: status, env: stub(url: enrollments_response_url)))
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
      'junk' => 'data'
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
      'junk' => 'data'
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
      'junk' => 'data'
    }
  end

  let(:classes_response_url) { stub(path: OneRoster::CLASSES_ENDPOINT) }
  let(:classes_body) { { 'classes' => [class_1, class_2, class_3] } }
  let(:classes_response) do
    OneRoster::Response.new(stub(body: classes_body, status: status, env: stub(url: classes_response_url)))
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
    OneRoster::Response.new(stub(body: courses_body, status: status, env: stub(url: courses_response_url)))
  end
end
