# frozen_string_literal: true

require 'spec_helper'

RSpec.describe OneRoster::Client do
  include_context 'api responses'

  let(:app_id) { 'app_id' }
  let(:app_secret) { 'app_secret' }
  let(:api_url) { 'https://bjulez.oneroster.com/' }
  let(:status) { 200 }

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
    before { mock_authentication }

    context 'successful authentication' do
      it 'sets authenticated status' do
        expect { client.authenticate }
          .to change { client.authenticated? }.from(false).to(true)
      end
    end

    context 'connection error' do
      let(:status) { 401 }
      it 'raises error' do
        expect { client.authenticate }.to raise_error(OneRoster::ConnectionError)
      end
    end
  end

  describe 'students' do
    before do
      mock_authentication
      mock_request(OneRoster::STUDENTS_ENDPOINT, students_response)
    end

    it 'authenticate and returns active students' do
      response = client.students
      expect(client.authenticated?).to be(true)

      first_student  = response[0]
      second_student = response[1]

      expect(first_student).to be_a(OneRoster::Types::Student)
      expect(first_student.id).to eq(student_1['sourcedId'])
      expect(first_student.first_name).to eq(student_1['givenName'])
      expect(first_student.last_name).to eq(student_1['familyName'])
      expect(first_student.username).to eq(student_1['username'])
      expect(first_student.status).to eq(student_1['status'])
      expect(first_student.provider).to eq('oneroster')

      expect(second_student).to be_a(OneRoster::Types::Student)
      expect(second_student.id).to eq(student_3['sourcedId'])
      expect(second_student.first_name).to eq(student_3['givenName'])
      expect(second_student.last_name).to eq(student_3['familyName'])
      expect(second_student.username).to eq(student_3['username'])
      expect(second_student.status).to eq(student_3['status'])
      expect(second_student.provider).to eq('oneroster')
    end
  end

  describe 'teachers' do
    before do
      mock_authentication
      mock_request(OneRoster::TEACHERS_ENDPOINT, teachers_response)
    end

    it 'authenticates and returns active teachers' do
      response = client.teachers
      expect(client.authenticated?).to be(true)

      first_teacher  = response[0]
      second_teacher = response[1]

      expect(first_teacher).to be_a(OneRoster::Types::Teacher)
      expect(first_teacher.id).to eq(teacher_1['sourcedId'])
      expect(first_teacher.email).to eq(teacher_1['email'])
      expect(first_teacher.first_name).to eq(teacher_1['givenName'])
      expect(first_teacher.last_name).to eq(teacher_1['familyName'])
      expect(first_teacher.status).to eq(teacher_1['status'])
      expect(first_teacher.provider).to eq('oneroster')

      expect(second_teacher).to be_a(OneRoster::Types::Teacher)
      expect(second_teacher.id).to eq(teacher_3['sourcedId'])
      expect(second_teacher.email).to eq(teacher_3['email'])
      expect(second_teacher.first_name).to eq(teacher_3['givenName'])
      expect(second_teacher.last_name).to eq(teacher_3['familyName'])
      expect(second_teacher.status).to eq(teacher_3['status'])
      expect(second_teacher.provider).to eq('oneroster')
    end
  end

  describe 'classes' do
    before do
      mock_authentication
      mock_request(OneRoster::CLASSES_ENDPOINT, classes_response)
    end
    it 'authenticates and returns classes' do
      response = client.classes
      expect(client.authenticated?).to be(true)

      first_class  = response[0]
      second_class = response[1]

      expect(first_class).to be_a(OneRoster::Types::Class)
      expect(first_class.id).to eq(class_1['sourcedId'])
      expect(first_class.course_id).to eq(class_1['course']['sourcedId'])
      expect(first_class.provider).to eq('oneroster')

      expect(second_class).to be_a(OneRoster::Types::Class)
      expect(second_class.id).to eq(class_3['sourcedId'])
      expect(second_class.course_id).to eq(class_3['course']['sourcedId'])
      expect(second_class.provider).to eq('oneroster')
    end

  end

  describe 'courses' do
    before do
      mock_authentication
      mock_request(OneRoster::CLASSES_ENDPOINT, classes_response)
      mock_request(OneRoster::COURSES_ENDPOINT, courses_response)
    end

    context 'without course_codes passed in' do
      it 'returns active courses whose ids are found in classes' do
        response = client.courses

        expect(response.length).to eq(2)

        first_course  = response[0]
        second_course = response[1]

        expect(first_course).to be_a(OneRoster::Types::Course)
        expect(first_course.id).to eq(course_1['sourcedId'])
        expect(first_course.course_code).to eq(course_1['courseCode'])
        expect(first_course.provider).to eq('oneroster')

        expect(second_course).to be_a(OneRoster::Types::Course)
        expect(second_course.id).to eq(course_3['sourcedId'])
        expect(second_course.course_code).to eq(course_3['courseCode'])
        expect(second_course.provider).to eq('oneroster')
      end
    end

    context 'with course_codes passed in' do
      it 'returns active courses whose ids are found in classes or codes in course_codes' do
        response = client.courses(course_4['courseCode'])

        first_course  = response[0]
        second_course = response[1]
        third_course  = response[2]

        expect(response.length).to eq(3)

        expect(first_course).to be_a(OneRoster::Types::Course)
        expect(first_course.id).to eq(course_1['sourcedId'])
        expect(first_course.course_code).to eq(course_1['courseCode'])
        expect(first_course.provider).to eq('oneroster')

        expect(second_course).to be_a(OneRoster::Types::Course)
        expect(second_course.id).to eq(course_3['sourcedId'])
        expect(second_course.course_code).to eq(course_3['courseCode'])
        expect(second_course.provider).to eq('oneroster')

        expect(third_course).to be_a(OneRoster::Types::Course)
        expect(third_course.id).to eq(course_4['sourcedId'])
        expect(third_course.course_code).to eq(course_4['courseCode'])
        expect(third_course.provider).to eq('oneroster')
      end

    end
  end

  describe 'enrollments' do
    before do
      mock_authentication
      mock_request(OneRoster::ENROLLMENTS_ENDPOINT, enrollments_response)
    end

    it 'authenticates and returns enrollments' do
      response = client.enrollments
      expect(client.authenticated?).to be(true)

      first_enrollment  = response[0]
      second_enrollment = response[1]

      expect(first_enrollment).to be_a(OneRoster::Types::Enrollment)
      expect(first_enrollment.id).to eq(enrollment_1['sourcedId'])
      expect(first_enrollment.classroom_id).to eq(enrollment_1['class']['sourcedId'])
      expect(first_enrollment.user_id).to eq(enrollment_1['user']['sourcedId'])
      expect(first_enrollment.provider).to eq('oneroster')

      expect(second_enrollment).to be_a(OneRoster::Types::Enrollment)
      expect(second_enrollment.id).to eq(enrollment_2['sourcedId'])
      expect(second_enrollment.classroom_id).to eq(enrollment_2['class']['sourcedId'])
      expect(second_enrollment.user_id).to eq(enrollment_2['user']['sourcedId'])
      expect(second_enrollment.provider).to eq('oneroster')
    end
  end
end
