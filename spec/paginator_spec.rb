# frozen_string_literal: true

require 'ostruct'
require 'spec_helper'

RSpec.describe OneRoster::Paginator do
  include_context 'api responses'

  let(:connection) { OneRoster::Connection.new(client) }
  let(:paginator) do
    OneRoster::Paginator.fetch(
      connection, OneRoster::ENROLLMENTS_ENDPOINT,
      :get, OneRoster::Types::Enrollment, 0, 2
    )
  end

  let(:page_1_response) do
    OneRoster::Response.new(
      OpenStruct.new(
        body: OpenStruct.new(enrollments: [enrollment_1, enrollment_2]),
        status: 200,
        env: OpenStruct.new(url: enrollments_response_url)
      )
    )
  end

  let(:page_2_response) do
    OneRoster::Response.new(
      OpenStruct.new(
        body: OpenStruct.new(enrollments: [enrollment_3, enrollment_4]),
        status: 200,
        env: OpenStruct.new(url: enrollments_response_url)
      )
    )
  end

  let(:page_3_response) do
    OneRoster::Response.new(
      OpenStruct.new(
        body: OpenStruct.new(enrollments: [enrollment_5]),
        status: 200,
        env: OpenStruct.new(url: enrollments_response_url)
      )
    )
  end
  describe '#fetch' do
    before do
      connection.expects(:execute)
        .with(OneRoster::ENROLLMENTS_ENDPOINT, :get, limit: 2, offset: 0)
        .returns(page_1_response)

      connection.expects(:execute)
        .with(OneRoster::ENROLLMENTS_ENDPOINT, :get, limit: 2, offset: 2)
        .returns(page_2_response)

      connection.expects(:execute)
        .with(OneRoster::ENROLLMENTS_ENDPOINT, :get, limit: 2, offset: 4)
        .returns(page_3_response)
    end

    it 'does something' do
      enrollments = paginator.force

      expect(enrollments.length).to eq(3)

      first_enrollment  = enrollments[0]
      second_enrollment = enrollments[1]
      third_enrollment  = enrollments[2]

      expect(first_enrollment).to be_a(OneRoster::Types::Enrollment)
      expect(first_enrollment.id).to eq(enrollment_1['sourcedId'])
      expect(first_enrollment.classroom_id).to eq(enrollment_1['class']['sourcedId'])
      expect(first_enrollment.user_id).to eq(enrollment_1['user']['sourcedId'])
      expect(first_enrollment.role).to eq(enrollment_1['role'])
      expect(first_enrollment.teacher?).to be(true)
      expect(first_enrollment.student?).to be(false)
      expect(first_enrollment.primary_teacher?).to be(true)
      expect(first_enrollment.provider).to eq('oneroster')

      expect(second_enrollment).to be_a(OneRoster::Types::Enrollment)
      expect(second_enrollment.id).to eq(enrollment_3['sourcedId'])
      expect(second_enrollment.classroom_id).to eq(enrollment_3['class']['sourcedId'])
      expect(second_enrollment.user_id).to eq(enrollment_3['user']['sourcedId'])
      expect(second_enrollment.role).to eq(enrollment_3['role'])
      expect(second_enrollment.teacher?).to be(true)
      expect(second_enrollment.student?).to be(false)
      expect(second_enrollment.primary_teacher?).to be(false)
      expect(second_enrollment.provider).to eq('oneroster')

      expect(third_enrollment).to be_a(OneRoster::Types::Enrollment)
      expect(third_enrollment.id).to eq(enrollment_4['sourcedId'])
      expect(third_enrollment.classroom_id).to eq(enrollment_4['class']['sourcedId'])
      expect(third_enrollment.user_id).to eq(enrollment_4['user']['sourcedId'])
      expect(third_enrollment.role).to eq(enrollment_4['role'])
      expect(third_enrollment.teacher?).to be(true)
      expect(third_enrollment.student?).to be(false)
      expect(third_enrollment.primary_teacher?).to be(true)
      expect(third_enrollment.provider).to eq('oneroster')
    end
  end
end
