# frozen_string_literal: true

module OneRoster
  class Client
    attr_accessor :app_id, :api_url, :app_secret, :logger, :vendor_key,
                  :shared_classes

    attr_reader :authenticated

    def initialize
      @authenticated = false
    end

    def self.configure
      client = new
      yield(client) if block_given?
      client
    end

    %i(students teachers classes).each do |record_type|
      define_method(record_type) do |record_ids = []|
        authenticate

        endpoint = OneRoster.const_get("#{record_type.upcase}_ENDPOINT")

        type = Types.const_get(Dry::Inflector.new.singularize(record_type.to_s.capitalize))

        records = Paginator.fetch(connection, endpoint, :get, type).force

        return records if record_ids.empty?

        records.select { |record| record_ids.include?(record.id) }
      end
    end

    def classrooms(course_codes = [])
      authenticate

      oneroster_classes = classes

      courses = courses(course_codes, oneroster_classes)

      oneroster_classes.each_with_object([]) do |oneroster_class, oneroster_classes|
        course = courses.find { |course| course.id == oneroster_class.course_id}
        next unless course

        oneroster_classes << Types::Classroom.new(course, oneroster_class)
      end
    end

    def courses(course_codes = [], oneroster_classes = classes)
      authenticate

      class_course_numbers = oneroster_classes.map(&:course_id)

      courses = Paginator.fetch(connection, COURSES_ENDPOINT, :get, Types::Course).force

      parse_courses(courses, course_codes, class_course_numbers)
    end

    def enrollments(classroom_ids = [])
      authenticate

      enrollments = parse_enrollments(classroom_ids)

      p "Found #{enrollments.values.flatten.length} enrollments."

      enrollments
    end

    def authenticate
      return if authenticated?

      response = connection.execute(TEACHERS_ENDPOINT, :get, limit: 1)

      raise ConnectionError unless response.success?

      @authenticated = true
    end

    def authenticated?
      @authenticated
    end

    def connection
      @connection ||= Connection.new(self)
    end

    private

    def parse_enrollments(classroom_ids)
      enrollments = Paginator.fetch(connection, ENROLLMENTS_ENDPOINT, :get, Types::Enrollment).force

      enrollments.each_with_object(teacher: [], student: []) do |enrollment, enrollments|
        next if classroom_ids.any? && !classroom_ids.include?(enrollment.classroom_id)

        enrollments[enrollment.role.to_sym] << enrollment if enrollment.valid?
      end
    end

    def parse_courses(courses, course_codes, course_numbers)
      courses.select do |course|
        in_course_numbers = course_numbers.include?(course.id)

        if course_codes.any?
          course_codes.include?(course.course_code) && in_course_numbers
        else
          in_course_numbers
        end
      end
    end
  end
end
