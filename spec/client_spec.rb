# frozen_string_literal: true

require 'spec_helper'

RSpec.describe OneRoster::Client do
  include_context 'api responses'

  it 'is configurable' do
    expect(client).to be_a(OneRoster::Client)
    expect(client.app_id).to eq(app_id)
    expect(client.app_secret).to eq(app_secret)
    expect(client.api_url).to eq(api_url)
  end

  describe 'authentication' do
    context 'oauth2 authentication' do
      before { mock_oauth2_authentication }

      it 'sets authenticated status' do
        expect { oauth2_client.authenticate }
          .to change { oauth2_client.authenticated? }.from(false).to(true)
      end

      context 'connection error' do
        let(:status) { 401 }
        it 'raises error' do
          expect { oauth2_client.authenticate }.to raise_error(OneRoster::ConnectionError)
        end
      end
    end

    context 'oauth authentication' do
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
  end

  describe 'students' do
    before do
      mock_authentication
      mock_request(OneRoster::STUDENTS_ENDPOINT, students_response)
    end

    context 'without uids passed in' do
      it 'authenticates and returns active students' do
        response = client.students
        expect(client.authenticated?).to be(true)

        first_student  = response[0]
        second_student = response[1]

        expect(first_student).to be_a(OneRoster::Types::Student)
        expect(first_student.uid).to eq(student_1['sourcedId'])
        expect(first_student.first_name).to eq(student_1['givenName'])
        expect(first_student.last_name).to eq(student_1['familyName'])
        expect(first_student.username).to eq(student_1['sourcedId'])
        expect(first_student.provider).to eq('oneroster')

        expect(second_student).to be_a(OneRoster::Types::Student)
        expect(second_student.uid).to eq(student_3['sourcedId'])
        expect(second_student.first_name).to eq(student_3['givenName'])
        expect(second_student.last_name).to eq(student_3['familyName'])
        expect(second_student.username).to eq(student_3['email'])
        expect(second_student.provider).to eq('oneroster')
      end
    end

    context 'with uids passed in' do
      it 'authenticates and returns students whose uids have been passed in' do
        response = client.students([student_1['sourcedId']])
        expect(client.authenticated?).to be(true)

        expect(response.length).to eq(1)

        student = response[0]

        expect(student).to be_a(OneRoster::Types::Student)
        expect(student.uid).to eq(student_1['sourcedId'])
        expect(student.first_name).to eq(student_1['givenName'])
        expect(student.last_name).to eq(student_1['familyName'])
        expect(student.username).to eq(student_1['sourcedId'])
        expect(student.provider).to eq('oneroster')
      end
    end

    context 'with username_source' do
      context 'username' do
        let(:username_source) { 'username' }
        it 'returns the proper usernames' do
          response = client.students

          expect(response.length).to eq(3)

          first_student  = response[0]
          second_student = response[1]
          third_student  = response[2]

          expect(first_student.username).to eq(student_1['sourcedId'])
          expect(second_student.username).to eq(student_3['email'])
          expect(third_student.username).to eq(student_4['username'])
        end
      end

      context 'email' do
        let(:username_source) { 'email' }
        it 'returns the proper usernames' do
          response = client.students

          expect(response.length).to eq(3)

          first_student  = response[0]
          second_student = response[1]
          third_student  = response[2]

          expect(first_student.username).to eq(student_1['sourcedId'])
          expect(second_student.username).to eq(student_3['email'])
          expect(third_student.username).to eq(student_4['email'])
        end
      end

      context 'sourcedId' do
        let(:username_source) { 'sourcedId' }
        it 'returns the proper usernames' do
          response = client.students

          expect(response.length).to eq(3)

          first_student  = response[0]
          second_student = response[1]
          third_student  = response[2]

          expect(first_student.username).to eq(student_1['sourcedId'])
          expect(second_student.username).to eq(student_3['sourcedId'])
          expect(third_student.username).to eq(student_4['username'])
        end
      end
    end
  end

  describe 'teachers' do
    before do
      mock_authentication
      mock_request(OneRoster::TEACHERS_ENDPOINT, teachers_response)
    end

    context 'without uids passed in' do
      it 'authenticates and returns active teachers' do
        response = client.teachers
        expect(client.authenticated?).to be(true)

        expect(response.length).to eq(2)

        first_teacher  = response[0]
        second_teacher = response[1]

        expect(first_teacher).to be_a(OneRoster::Types::Teacher)
        expect(first_teacher.uid).to eq(teacher_1['sourcedId'])
        expect(first_teacher.email).to eq(teacher_1['email'])
        expect(first_teacher.first_name).to eq(teacher_1['givenName'])
        expect(first_teacher.last_name).to eq(teacher_1['familyName'])
        expect(first_teacher.provider).to eq('oneroster')

        expect(second_teacher).to be_a(OneRoster::Types::Teacher)
        expect(second_teacher.uid).to eq(teacher_3['sourcedId'])
        expect(second_teacher.email).to eq(teacher_3['email'])
        expect(second_teacher.first_name).to eq(teacher_3['givenName'])
        expect(second_teacher.last_name).to eq(teacher_3['familyName'])
        expect(second_teacher.provider).to eq('oneroster')
      end
    end

    context 'with uids passed in' do
      it 'authenticates and returns teachers whose uids have been passed in' do
        response = client.teachers([teacher_1['sourcedId']])
        expect(client.authenticated?).to be(true)

        expect(response.length).to eq(1)

        teacher = response[0]

        expect(teacher).to be_a(OneRoster::Types::Teacher)
        expect(teacher.uid).to eq(teacher_1['sourcedId'])
        expect(teacher.email).to eq(teacher_1['email'])
        expect(teacher.first_name).to eq(teacher_1['givenName'])
        expect(teacher.last_name).to eq(teacher_1['familyName'])
        expect(teacher.provider).to eq('oneroster')
      end
    end

    context 'with username source' do
      context 'username' do
        let(:staff_username_source) { 'username' }

        it 'returns the proper usernames' do
          response = client.teachers

          expect(response.length).to eq(2)

          first_teacher  = response[0]
          second_teacher = response[1]

          expect(first_teacher.username).to eq(teacher_1['username'])
          expect(second_teacher.username).to be_nil
        end
      end

      context 'email' do
        let(:staff_username_source) { 'email' }

        it 'returns the proper usernames' do
          response = client.teachers

          expect(response.length).to eq(2)

          first_teacher  = response[0]
          second_teacher = response[1]

          expect(first_teacher.username).to eq(teacher_1['email'])
          expect(second_teacher.username).to eq(teacher_3['email'])
        end
      end

      context 'sourcedId' do
        let(:staff_username_source) { 'sourcedId' }

        it 'returns the proper usernames' do
          response = client.teachers

          expect(response.length).to eq(2)

          first_teacher  = response[0]
          second_teacher = response[1]

          expect(first_teacher.username).to eq(teacher_1['sourcedId'])
          expect(second_teacher.username).to eq(teacher_3['sourcedId'])
        end
      end
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
      expect(first_class.uid).to eq(class_1['sourcedId'])
      expect(first_class.title).to eq('Soc Studies 3 - B. Julez')
      expect(first_class.course_uid).to eq(class_1['course']['sourcedId'])
      expect(first_class.period).to eq('1')
      expect(first_class.subjects).to eq([])
      expect(first_class.grades).to eq(class_1['grades'])
      expect(first_class.provider).to eq('oneroster')

      expect(second_class).to be_a(OneRoster::Types::Class)
      expect(second_class.uid).to eq(class_3['sourcedId'])
      expect(second_class.title).to eq('Meme Studies 3 - B. Julez')
      expect(second_class.course_uid).to eq(class_3['course']['sourcedId'])
      expect(second_class.period).to eq('3')
      expect(second_class.subjects).to eq(class_3['subjects'])
      expect(second_class.grades).to eq(class_3['grades'])
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
      it 'authenticates and returns active courses whose uids are found in classes' do
        response = client.courses
        expect(client.authenticated?).to be(true)

        expect(response.length).to eq(2)

        first_course  = response[0]
        second_course = response[1]

        expect(first_course).to be_a(OneRoster::Types::Course)
        expect(first_course.uid).to eq(course_1['sourcedId'])
        expect(first_course.course_code).to eq(course_1['courseCode'])
        expect(first_course.provider).to eq('oneroster')

        expect(second_course).to be_a(OneRoster::Types::Course)
        expect(second_course.uid).to eq(course_3['sourcedId'])
        expect(second_course.course_code).to eq(course_3['courseCode'])
        expect(second_course.provider).to eq('oneroster')
      end
    end

    context 'with course_codes passed in' do
      it 'authenticates and returns active courses whose uids are in classes and codes in course_codes' do
        response = client.courses([course_1['courseCode']])
        expect(client.authenticated?).to be(true)

        expect(response.length).to eq(1)

        course = response[0]

        expect(course).to be_a(OneRoster::Types::Course)
        expect(course.uid).to eq(course_1['sourcedId'])
        expect(course.course_code).to eq(course_1['courseCode'])
        expect(course.provider).to eq('oneroster')
      end
    end
  end

  describe 'classrooms' do
    before do
      mock_authentication
      mock_request(OneRoster::CLASSES_ENDPOINT, classes_response)
      mock_request(OneRoster::COURSES_ENDPOINT, courses_response)
      mock_request(OneRoster::ACADEMIC_SESSIONS_ENDPOINT, terms_response)
    end

    context 'without course_codes passed in' do
      it 'authenticates and returns classrooms from active courses whose uids are found in classes' do
        response = client.classrooms
        expect(client.authenticated?).to be(true)

        expect(response.length).to eq(2)

        first_classroom  = response[0]
        second_classroom = response[1]

        expect(first_classroom).to be_a(OneRoster::Types::Classroom)
        expect(first_classroom.uid).to eq(class_1['sourcedId'])
        expect(first_classroom.course_number).to eq(course_1['courseCode'])
        expect(first_classroom.period).to eq('1')
        expect(first_classroom.grades).to eq(class_1['grades'])
        expect(first_classroom.subjects).to eq([])
        expect(first_classroom.term_name).to eq('term name')
        expect(first_classroom.term_start_date).to eq('2019-08-21')
        expect(first_classroom.term_end_date).to eq('2020-01-10')
        expect(first_classroom.provider).to eq('oneroster')

        expect(second_classroom).to be_a(OneRoster::Types::Classroom)
        expect(second_classroom.uid).to eq(class_3['sourcedId'])
        expect(second_classroom.course_number).to eq(course_3['courseCode'])
        expect(second_classroom.period).to eq('3')
        expect(second_classroom.grades).to eq(class_3['grades'])
        expect(second_classroom.subjects).to eq(class_3['subjects'])
        expect(second_classroom.provider).to eq('oneroster')
      end
    end

    context 'with course_codes passed in' do
      it 'authenticates and returns classrooms from active courses whose uids are  in classes'\
      'and codes in course_codes' do
        response = client.classrooms([course_1['courseCode']])
        expect(client.authenticated?).to be(true)

        expect(response.length).to eq(1)

        classroom = response[0]

        expect(classroom).to be_a(OneRoster::Types::Classroom)
        expect(classroom.uid).to eq(class_1['sourcedId'])
        expect(classroom.course_number).to eq(course_1['courseCode'])
        expect(classroom.period).to eq('1')
        expect(classroom.grades).to eq(class_1['grades'])
        expect(classroom.provider).to eq('oneroster')
      end
    end
  end

  describe 'enrollments' do
    before do
      mock_authentication
      mock_request(OneRoster::ENROLLMENTS_ENDPOINT, enrollments_response)
    end

    context 'without classroom_uids passed in' do
      it 'authenticates and returns enrollments' do
        response = client.enrollments
        expect(client.authenticated?).to be(true)

        expect(response[:teacher].length).to eq(3)
        expect(response[:student].length).to eq(1)

        teacher_enrollment1 = response[:teacher][0]
        teacher_enrollment2 = response[:teacher][1]
        teacher_enrollment3 = response[:teacher][2]
        student_enrollment = response[:student][0]

        expect(teacher_enrollment1).to be_a(OneRoster::Types::Enrollment)
        expect(teacher_enrollment1.uid).to eq(enrollment_1['sourcedId'])
        expect(teacher_enrollment1.classroom_uid).to eq(enrollment_1['class']['sourcedId'])
        expect(teacher_enrollment1.user_uid).to eq(enrollment_1['user']['sourcedId'])
        expect(teacher_enrollment1.role).to eq(enrollment_1['role'])
        expect(teacher_enrollment1.teacher?).to be(true)
        expect(teacher_enrollment1.student?).to be(false)
        expect(teacher_enrollment1.primary).to eq(true)
        expect(teacher_enrollment1.provider).to eq('oneroster')

        expect(teacher_enrollment2).to be_a(OneRoster::Types::Enrollment)
        expect(teacher_enrollment2.uid).to eq(enrollment_3['sourcedId'])
        expect(teacher_enrollment2.classroom_uid).to eq(enrollment_3['class']['sourcedId'])
        expect(teacher_enrollment2.user_uid).to eq(enrollment_3['user']['sourcedId'])
        expect(teacher_enrollment2.role).to eq(enrollment_3['role'])
        expect(teacher_enrollment2.teacher?).to be(true)
        expect(teacher_enrollment2.student?).to be(false)
        expect(teacher_enrollment2.primary).to eq(false)
        expect(teacher_enrollment2.provider).to eq('oneroster')

        expect(teacher_enrollment3).to be_a(OneRoster::Types::Enrollment)
        expect(teacher_enrollment3.uid).to eq(enrollment_4['sourcedId'])
        expect(teacher_enrollment3.classroom_uid).to eq(enrollment_4['class']['sourcedId'])
        expect(teacher_enrollment3.user_uid).to eq(enrollment_4['user']['sourcedId'])
        expect(teacher_enrollment3.role).to eq(enrollment_4['role'])
        expect(teacher_enrollment3.teacher?).to be(true)
        expect(teacher_enrollment3.student?).to be(false)
        expect(teacher_enrollment3.primary).to eq(true)
        expect(teacher_enrollment3.provider).to eq('oneroster')

        expect(student_enrollment).to be_a(OneRoster::Types::Enrollment)
        expect(student_enrollment.uid).to eq(enrollment_6['sourcedId'])
        expect(student_enrollment.classroom_uid).to eq(enrollment_6['class']['sourcedId'])
        expect(student_enrollment.user_uid).to eq(enrollment_6['user']['sourcedId'])
        expect(student_enrollment.role).to eq(enrollment_6['role'])
        expect(student_enrollment.teacher?).to be(false)
        expect(student_enrollment.primary).to eq(false)
        expect(student_enrollment.student?).to be(true)
        expect(student_enrollment.provider).to eq('oneroster')
      end
    end

    context 'with classroom_uids passed in' do
      it 'authenticates and only returns enrollments with classrooms in classroom_uids' do
        response = client.enrollments([class_1['sourcedId']])
        expect(client.authenticated?).to be(true)

        expect(response[:teacher].length).to eq(2)
        expect(response[:student].length).to eq(0)

        teacher_enrollment = response[:teacher][0]

        expect(teacher_enrollment).to be_a(OneRoster::Types::Enrollment)
        expect(teacher_enrollment.uid).to eq(enrollment_1['sourcedId'])
        expect(teacher_enrollment.classroom_uid).to eq(enrollment_1['class']['sourcedId'])
        expect(teacher_enrollment.user_uid).to eq(enrollment_1['user']['sourcedId'])
        expect(teacher_enrollment.role).to eq(enrollment_1['role'])
        expect(teacher_enrollment.teacher?).to be(true)
        expect(teacher_enrollment.student?).to be(false)
        expect(teacher_enrollment.primary).to be(enrollment_1['primary'])
        expect(teacher_enrollment.provider).to eq('oneroster')
      end
    end
  end

  describe '#token' do
    context 'when no token is provided' do
      it 'uses the default token path' do
        client.connection.expects(:execute)
                     .with("#{client.api_url}/token", :post)
        client.token
      end
    end

    context 'when a token is provided' do
      let(:client) do
        OneRoster::Client.configure do |config|
          config.app_id                = app_id
          config.app_secret            = app_secret
          config.api_url               = api_url
          config.username_source       = username_source
          config.staff_username_source = staff_username_source
          config.token_url             = token_url
        end
      end

      it 'uses the provided token path' do
        client.connection.expects(:execute)
              .with(token_url, :post)
        client.token
      end
    end
  end

  describe 'types .to_h' do
    context 'teacher' do
      it 'serializes the expected fields' do
        teacher = OneRoster::Types::Teacher.new(teacher_1)

        expect(teacher.to_h).to eq(
          uid: teacher_1['sourcedId'],
          email: teacher_1['email'],
          first_name: teacher_1['givenName'],
          last_name: teacher_1['familyName'],
          username: nil,
          provider: 'oneroster'
        )
      end
    end

    context 'enrollments' do
      it 'serializes the expected fields' do
        enrollment = OneRoster::Types::Enrollment.new(enrollment_1)
        expect(enrollment.to_h).to eq(
          classroom_uid: class_1['sourcedId'],
          user_uid: teacher_1['sourcedId'],
          primary: enrollment_1['primary'],
          provider: 'oneroster'
        )
      end
    end

    context 'students' do
      it 'returns in the expected format' do
        student = OneRoster::Types::Student.new(student_1)
        expect(student.to_h).to eq(
          uid: student_1['sourcedId'],
          first_name: student_1['givenName'],
          last_name: student_1['familyName'],
          username: student_1['sourcedId'],
          provider: 'oneroster'
        )
      end
    end
  end
end
